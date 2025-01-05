import 'package:flutter/material.dart';
import 'package:flutter_gauges/domain/gauge_values.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../net/gauge_socket.dart';
import 'gauges.dart';

Widget getAFRGauge(ValueNotifier<GaugeValues> gaugeValueNotifier) {
  return ValueListenableBuilder<GaugeValues>(
      valueListenable: gaugeValueNotifier, builder: _buildAFRGauge);
}

Widget _buildAFRGauge(
    BuildContext context, GaugeValues gaugeValue, Widget? child) {
  var afrValuePointer = MarkerPointer(
    animationDuration: expectedMessageRateMillis,
    animationType: AnimationType.linear,
    enableAnimation: true,
    value: gaugeValue.afrValue,
    markerType: MarkerType.triangle,
    markerOffset: 5,
    markerWidth: 15,
    markerHeight: 20,
    color: Colors.white,
  );

  var afrTargetPointer = MarkerPointer(
    animationDuration: expectedMessageRateMillis,
    animationType: AnimationType.linear,
    enableAnimation: true,
    value: gaugeValue.afrTarget,
    markerType: MarkerType.triangle,
    markerOffset: 5,
    markerWidth: 15,
    markerHeight: 20,
    color: Colors.blueGrey,
  );

  return SfRadialGauge(
    enableLoadingAnimation: isInitialDisplay(),
    animationDuration: 4000,
    axes: <RadialAxis>[
      RadialAxis(
        useRangeColorForAxis: true,
        startAngle: 130,
        endAngle: 50,
        minimum: 7,
        maximum: 21,
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 7,
            endValue: 21,
            gradient: SweepGradient(stops: [
              0.15,
              0.20,
              0.50,
              0.80,
              0.85,
            ], colors: [
              Colors.red,
              Colors.orange,
              Colors.green,
              Colors.orange,
              Colors.red
            ]),
          ),
        ],
        pointers: [afrTargetPointer, afrValuePointer],
        annotations: [
          GaugeAnnotation(
            widget: Text("Lean", style: TextStyle(fontSize: 10)),
            angle: 0,
            positionFactor: 0.7,
          ),
          GaugeAnnotation(
            widget: Text(
              gaugeValue.afrValue.toStringAsFixed(2).padLeft(5),
              style: TextStyle(fontSize: 25),
            ),
            angle: 90,
            positionFactor: 0,
          ),
          GaugeAnnotation(
            widget: Text("AFR", style: TextStyle(fontSize: 15)),
            angle: 90,
            positionFactor: 0.4,
          ),
          GaugeAnnotation(
            widget:
                Text("(Parts air to 1 Fuel)", style: TextStyle(fontSize: 10)),
            angle: 90,
            positionFactor: 0.5,
          ),
          GaugeAnnotation(
            widget: Text("Rich", style: TextStyle(fontSize: 10)),
            angle: 180,
            positionFactor: 0.7,
          )
        ],
      ),
    ],
  );
}
