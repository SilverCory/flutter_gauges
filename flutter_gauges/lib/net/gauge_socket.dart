import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_gauges/domain/gauge_values.dart';

const double expectedMessageRateMillis = 100;

class GaugeSocket {
  late final InternetAddress host;
  late final Function(GaugeValues) callback;

  Socket? socket;
  bool _closed = false;
  Completer<void>? _reconnectTrigger;

  GaugeSocket({required socketPath, required this.callback}) {
    print(socketPath);
    host = InternetAddress(socketPath, type: InternetAddressType.unix);
  }

  Future<void> connectAndListen() async {
    while (!_closed) {
      try {
        print("Attempting to connect...");
        socket = await Socket.connect(host, 0);
        print("Connected to $host");

        // Setup listeners for the new socket
        _setupSocketListeners();

        // Wait until the socket is closed or the connection is lost
        _reconnectTrigger = Completer<void>();
        await _reconnectTrigger!.future;
      } catch (e) {
        print("Connection failed: $e");
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void _setupSocketListeners() {
    print("Connected! Setting up listeners");
    socket!
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(LineSplitter()) // Split into lines
        .listen(
      (line) {
        try {
          final GaugeValues jsonData =
              GaugeValues.fromJson(jsonDecode(line) as Map<String, dynamic>);
          callback(jsonData);
        } catch (e) {
          print('Failed to parse JSON: $e');
        }
      },
      onDone: () {
        print("Socket disconnected.");
        _triggerReconnect();
      },
      cancelOnError: false,
    );
  }

  void _triggerReconnect() {
    print("Killing and reconnecting.");
    // Cleanup and trigger reconnection
    if (socket != null) {
      try {
        socket!.destroy();
      } catch (e) {
        print("Error during cleanup: $e");
      }
      socket = null;
    }

    if (_reconnectTrigger != null && !_reconnectTrigger!.isCompleted) {
      _reconnectTrigger!.complete();
    }
  }

  void destroy() {
    _closed = true;
    _triggerReconnect();
  }
}
