import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gauges/display/gauge_display_wrapper.dart';
import 'package:flutter_gauges/domain/gauge_values_notifier.dart';
import 'package:flutter_gauges/net/gauge_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/gauge_type.dart';
import 'gauges.dart';
import 'gauge_display_afr.dart';
import 'gauge_display_boost.dart';

class GaugeDisplay extends StatefulWidget {
  late final String socketPath;
  late final SharedPreferences prefs;

  GaugeDisplay({super.key, required this.prefs}) {
    Directory appDirectory = Directory.systemTemp;
    socketPath = '${appDirectory.path}/flutter_gauges_backend.sock';
  }

  @override
  State<StatefulWidget> createState() {
    return _GaugeDisplayState();
  }
}

class _GaugeDisplayState extends State<GaugeDisplay> {
  final GaugeValuesNotifiers notifiers = GaugeValuesNotifiers();
  late final GaugeSocket gaugeSocket;

  DataType initialGauge = DataType.boostGauge;

  _GaugeDisplayState();

  @override
  void initState() {
    gaugeSocket = GaugeSocket(
      socketPath: widget.socketPath,
      callback: notifiers.imposeValues,
    );

    String? initialGaugeStr = widget.prefs.getString("displayedGauge");
    if (initialGaugeStr != null) {
      try {
        initialGauge = dataTypeFromString(initialGaugeStr);
      } catch (e) {
        // Ignored.
      }
    }

    super.initState();
    gaugeSocket.connectAndListen().ignore();
  }

  @override
  void dispose() {
    gaugeSocket.destroy();
    notifiers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: false,
          autoPlayAnimationDuration: Duration(seconds: 1),
          enableInfiniteScroll: true,
          autoPlayInterval: Duration(seconds: 3),
          scrollDirection: Axis.horizontal,
          height: height,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          animateToClosest: true,
          initialPage: DataType.values.indexOf(initialGauge),
          onPageChanged: (index, changeReason) => {
            initialDisplayDisplayed(),
            if (changeReason == CarouselPageChangedReason.manual)
              widget.prefs.setString(
                "displayedGauge",
                DataType.values[index].toString(),
              )
          },
        ),
        items: [
          GaugeDisplayWrapper(
            notifiers: notifiers,
            child: GaugeDisplayBoost(notifiers: notifiers),
          ),
          GaugeDisplayWrapper(
            notifiers: notifiers,
            child: GaugeDisplayAFR(notifiers: notifiers),
          ),
        ],
      ),
    );
  }
}
