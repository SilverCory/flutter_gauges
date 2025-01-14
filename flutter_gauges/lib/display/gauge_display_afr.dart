import 'package:flutter/material.dart';
import 'package:flutter_gauges/domain/gauge_values_notifier.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeDisplayAFR extends StatefulWidget {
  final GaugeValuesNotifiers notifiers;

  const GaugeDisplayAFR({super.key, required this.notifiers});

  @override
  State<StatefulWidget> createState() {
    return _GaugeDisplayAFRState();
  }
}

class _GaugeDisplayAFRState extends State<GaugeDisplayAFR> {
  double _afrValue = 0;
  double _afrTarget = 0;

  void _updateAFRValue() {
    setState(() {
      _afrValue = widget.notifiers.afrValue.value;
    });
  }

  void _updateAFRTarget() {
    setState(() {
      _afrTarget = widget.notifiers.afrTarget.value;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.notifiers.afrValue.addListener(_updateAFRValue);
    widget.notifiers.afrTarget.addListener(_updateAFRTarget);
  }

  @override
  void dispose() {
    widget.notifiers.afrValue.removeListener(_updateAFRValue);
    widget.notifiers.afrTarget.removeListener(_updateAFRTarget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: false,
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
          pointers: [
            MarkerPointer(
              enableAnimation: false,
              value: _afrTarget,
              markerType: MarkerType.triangle,
              markerOffset: 5,
              markerWidth: 15,
              markerHeight: 20,
              color: Colors.blueGrey,
            ),
            MarkerPointer(
              enableAnimation: false,
              value: _afrValue,
              markerType: MarkerType.triangle,
              markerOffset: 5,
              markerWidth: 15,
              markerHeight: 20,
              color: Colors.white,
            ),
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text(
                "Lean",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              angle: 0,
              positionFactor: 0.7,
            ),
            GaugeAnnotation(
              widget: Text(
                _afrValue.toStringAsFixed(2).padLeft(5),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              angle: 90,
              positionFactor: 0,
            ),
            GaugeAnnotation(
              widget: Text(
                "AFR",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              angle: 90,
              positionFactor: 0.4,
            ),
            GaugeAnnotation(
              widget: Text(
                "(Air:1Fuel)",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
            GaugeAnnotation(
              widget: Text(
                "Rich",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              angle: 180,
              positionFactor: 0.7,
            )
          ],
        ),
      ],
    );
  }
}
