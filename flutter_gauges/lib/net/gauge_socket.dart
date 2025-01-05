import 'dart:convert';
import 'dart:io';

import 'package:flutter_gauges/domain/gauge_values.dart';

const double expectedMessageRateMillis = 100;

class GaugeSocket {
  late final InternetAddress host;
  late final Function(GaugeValues) callback;

  late Socket socket;
  bool _closed = false;

  GaugeSocket({required socketPath, required this.callback}) {
    host = InternetAddress(socketPath, type: InternetAddressType.unix);
  }

  Future<void> connectAndListen() async {
    socket = await Socket.connect(host, 0);
    socket
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(LineSplitter()) // Split into lines
        .listen(
      onDone: () {
        if (_closed) return;
        socket.destroy();

        // TODO: This is jank
        var connecting = true;
        while (connecting) {
          try {
            connectAndListen(); // Recursion yay
            connecting = false;
          } catch (e) {
            // Ignored error
          }
          sleep(Duration(seconds: 5));
        }
      },
      (line) {
        try {
          final GaugeValues jsonData =
              GaugeValues.fromJson(jsonDecode(line) as Map<String, dynamic>);
          try {
            callback(jsonData);
          } catch (a) {
            // Ignore
          }
        } catch (e) {
          print('Failed to parse JSON: $e');
        }
      },
      cancelOnError: false,
    );
  }

  void destroy() {
    _closed = true;
    socket.destroy();
  }
}
