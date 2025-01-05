import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gauges/net/gauge_socket.dart';
import 'package:flutter_gauges/domain/gauge_values.dart';

import '../domain/gauge_type.dart';
import 'gauges.dart';
import 'gauge_display_afr.dart';
import 'gauge_display_boost.dart';

class GaugeDisplay extends StatefulWidget {
  late final String _socketPath;

  GaugeDisplay({super.key}) {
    Directory appDirectory = Directory.systemTemp;
    _socketPath = '${appDirectory.path}/flutter_gauges_backend.sock';
  }

  @override
  State<StatefulWidget> createState() {
    return _GaugeDisplayState(socketPath: _socketPath);
  }
}

class _GaugeDisplayState extends State<GaugeDisplay> {
  final ValueNotifier<GaugeValues> gaugeValuesNotifier =
      ValueNotifier(GaugeValues.zero());

  late Widget intakePressureGaugeWidget;
  late Widget afrGaugeWidget;

  late GaugeSocket gaugeSocket;

  _GaugeDisplayState({required socketPath}) {
    gaugeSocket =
        GaugeSocket(socketPath: socketPath, callback: updateValues);
  }

  @override
  void initState() {
    intakePressureGaugeWidget = getIntakePressureGauge(gaugeValuesNotifier);
    afrGaugeWidget = getAFRGauge(gaugeValuesNotifier);

    super.initState();
    gaugeSocket.connectAndListen();
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
      child: Container(),
    );
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
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              animateToClosest: true,
              initialPage: DataType.values.indexOf(DataType.afrGauge),
              onPageChanged: (index, changeReason) => {
                initialDisplayDisplayed(),
                if (changeReason == CarouselPageChangedReason.manual)
                  {
                    print(
                        "Page changed to: ${DataType.values[index].toString()}")
                    // TODO save index
                  }
              },
            ),
            items: DataType.values.toList().map((i) {
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
                    child: Material(child: render),
                  );
                },
              );
            }).toList(),
          ),
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
  }
}
