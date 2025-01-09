import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gauges/net/gauge_socket.dart';
import 'package:flutter_gauges/domain/gauge_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icons_flutter/icons_flutter.dart';

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
  final ValueNotifier<GaugeValues> gaugeValuesNotifier =
      ValueNotifier(GaugeValues.zero());

  late Widget intakePressureGaugeWidget;
  late Widget afrGaugeWidget;

  late GaugeSocket gaugeSocket;

  DataType initialGauge = DataType.boostGauge;

  _GaugeDisplayState() {}

  @override
  void initState() {
    gaugeSocket =
        GaugeSocket(socketPath: widget.socketPath, callback: updateValues);

    String? initialGaugeStr = widget.prefs.getString("displayedGauge");
    if (initialGaugeStr != null) {
      try {
        initialGauge = dataTypeFromString(initialGaugeStr);
      } catch (e) {
        // Ignored.
      }
    }

    intakePressureGaugeWidget = getIntakePressureGauge(gaugeValuesNotifier);
    afrGaugeWidget = getAFRGauge(gaugeValuesNotifier);

    super.initState();
    gaugeSocket.connectAndListen().ignore();
  }

  @override
  void dispose() {
    gaugeSocket.destroy();
    gaugeValuesNotifier.dispose();
    super.dispose();
  }

  void updateValues(GaugeValues values) {
    gaugeValuesNotifier.value = values;
  }

  Icon _iconTempratureCalc(temp) {
    if (temp < 50) {
      return Icon(
        FontAwesome.thermometer_empty,
        color: Colors.blue,
      );
    }

    if (temp > 120) {
      return Icon(
        FontAwesome.thermometer_full,
        color: Colors.red,
      );
    }

    return Icon(
      FontAwesome.thermometer_half,
      color: Colors.green.withOpacity(0.2),
    );
  }

  Widget _buildAlertContainer(
      BuildContext context, GaugeValues values, Widget? child) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: values.knocked
            ? Border.all(
                color: Colors.red,
                width: 18.0,
              )
            : null,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: height / 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Foundation.foot,
                    color: values.twoStep
                        ? Colors.orange
                        : Colors.grey.withOpacity(0.2),
                  ),
                  _iconTempratureCalc(values.waterTemperature),
                  Icon(
                    FontAwesome5Icon.oil_can,
                    color: values.oilPressure < 100
                        ? Colors.red
                        : Colors.green.withOpacity(0.2),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    dataTypeFromString(DataType.boostGauge.toString());
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          animateToClosest: true,
          initialPage: DataType.values.indexOf(initialGauge),
          onPageChanged: (index, changeReason) => {
            initialDisplayDisplayed(),
            if (changeReason == CarouselPageChangedReason.manual)
              {
                widget.prefs.setString(
                    "displayedGauge", DataType.values[index].toString())
              }
          },
        ),
        items: DataType.values.toList().map(
          (i) {
            return Builder(
              builder: (BuildContext context) {
                Widget render;
                switch (i) {
                  case DataType.boostGauge:
                    render = intakePressureGaugeWidget;
                    break;
                  case DataType.afrGauge:
                    render = afrGaugeWidget;
                    break;
                }

                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Stack(
                    children: [
                      Material(child: render),
                      IgnorePointer(
                        ignoring: true,
                        child: ValueListenableBuilder<GaugeValues>(
                          valueListenable: gaugeValuesNotifier,
                          builder: _buildAlertContainer,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
