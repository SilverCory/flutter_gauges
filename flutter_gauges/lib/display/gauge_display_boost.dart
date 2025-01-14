import 'package:flutter/material.dart';
import 'package:flutter_gauges/domain/gauge_values_notifier.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeDisplayBoost extends StatefulWidget {
  final GaugeValuesNotifiers notifiers;

  const GaugeDisplayBoost({super.key, required this.notifiers});

  @override
  State<StatefulWidget> createState() {
    return _GaugeDisplayBoostState();
  }
}

class _GaugeDisplayBoostState extends State<GaugeDisplayBoost> {
  double _intakePressure = 0;
  Color _colorBoostPointer = Colors.transparent;
  Color _colorVacuumPointer = Colors.transparent;

  @override
  void initState() {
    super.initState();

    // Start listening to the notifier
    widget.notifiers.intakePressure.addListener(_setIntakePressure);
  }

  @override
  void dispose() {
    widget.notifiers.intakePressure.removeListener(_setIntakePressure);
    super.dispose();
  }

  void _setIntakePressure() {
    setState(() {
      _intakePressure = widget.notifiers.intakePressure.value;
      _colorBoostPointer =
          _intakePressure > 0 ? Colors.white : Colors.transparent;
      _colorVacuumPointer =
          _intakePressure > 0 ? Colors.transparent : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: false,
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
          pointers: [
            MarkerPointer(
              enableAnimation: false,
              value: _intakePressure,
              markerType: MarkerType.triangle,
              markerOffset: 5,
              markerWidth: 15,
              markerHeight: 20,
              color: _colorVacuumPointer,
            ),
          ],
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
          pointers: <GaugePointer>[
            MarkerPointer(
              enableAnimation: false,
              value: _intakePressure,
              markerType: MarkerType.triangle,
              markerOffset: 5,
              markerWidth: 15,
              markerHeight: 20,
              color: _colorBoostPointer,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                "Boost",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              angle: 0,
              positionFactor: 0.7,
            ),
            GaugeAnnotation(
              widget: Text(
                _intakePressure.toStringAsFixed(1).padLeft(5).padRight(7),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              angle: 90,
              positionFactor: 0,
            ),
            GaugeAnnotation(
              widget: Text(
                "Intake Pressure",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              angle: 90,
              positionFactor: 0.4,
            ),
            GaugeAnnotation(
              widget: Text(
                "(lb/in²)",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
            GaugeAnnotation(
              widget: Text(
                "Vacuum",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              angle: 180,
              positionFactor: 0.7,
            )
          ],
        )
      ],
    );
  }
}
