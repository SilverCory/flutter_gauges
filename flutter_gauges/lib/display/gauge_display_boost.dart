import 'package:flutter/material.dart';
import 'package:flutter_gauges/display/gauges.dart';
import 'package:flutter_gauges/domain/gauge_values.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../net/gauge_socket.dart';

Widget getIntakePressureGauge(ValueNotifier<GaugeValues> gaugeValueNotifier) {
  return ValueListenableBuilder<GaugeValues>(
      valueListenable: gaugeValueNotifier, builder: _buildIntakePressureGauge);
}

Widget _buildIntakePressureGauge(
    BuildContext context, GaugeValues gaugeValue, Widget? child) {
  var vacuumPointer = MarkerPointer(
    animationDuration: expectedMessageRateMillis,
    animationType: AnimationType.linear,
    enableAnimation: true,
    value: gaugeValue.intakePressure,
    markerType: MarkerType.triangle,
    markerOffset: 5,
    markerWidth: 15,
    markerHeight: 20,
    color: gaugeValue.intakePressure > 0 ? Colors.transparent : Colors.white,
  );

  var boostPointer = MarkerPointer(
    animationDuration: expectedMessageRateMillis,
    animationType: AnimationType.linear,
    enableAnimation: true,
    value: gaugeValue.intakePressure,
    markerType: MarkerType.triangle,
    markerOffset: 5,
    markerWidth: 15,
    markerHeight: 20,
    color: gaugeValue.intakePressure > 0 ? Colors.white : Colors.transparent,
  );

  return SfRadialGauge(
    enableLoadingAnimation: isInitialDisplay(),
    animationDuration: 4000,
    axes: <RadialAxis>[
      RadialAxis(
        useRangeColorForAxis: true,
        startAngle: 130,
        endAngle: 270,
        minimum: -15,
        maximum: 0,
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: -15,
            endValue: -0,
            color: Colors.deepPurple,
          ),
        ],
        pointers: [vacuumPointer],
      ),
      RadialAxis(
        useRangeColorForAxis: true,
        startAngle: 270,
        endAngle: 50,
        minimum: 0,
        maximum: 10,
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 4,
            color: Colors.green,
          ),
          GaugeRange(
            startValue: 4,
            endValue: 6,
            color: Colors.orange,
          ),
          GaugeRange(
            startValue: 6,
            endValue: 10,
            color: Colors.red,
          )
        ],
        pointers: <GaugePointer>[boostPointer],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: Text("Boost", style: TextStyle(fontSize: 10)),
            angle: 0,
            positionFactor: 0.7,
          ),
          GaugeAnnotation(
            widget: Text(
              gaugeValue.intakePressure
                  .toStringAsFixed(1)
                  .padLeft(5)
                  .padRight(7),
              style: TextStyle(fontSize: 25),
            ),
            angle: 90,
            positionFactor: 0,
          ),
          GaugeAnnotation(
            widget: Text("Intake Pressure", style: TextStyle(fontSize: 15)),
            angle: 90,
            positionFactor: 0.4,
          ),
          GaugeAnnotation(
            widget: Text("(lb/in²)", style: TextStyle(fontSize: 10)),
            angle: 90,
            positionFactor: 0.5,
          ),
          GaugeAnnotation(
            widget: Text("Vacuum", style: TextStyle(fontSize: 10)),
            angle: 180,
            positionFactor: 0.7,
          )
        ],
      )
    ],
  );
}
