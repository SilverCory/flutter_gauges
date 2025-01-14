import 'package:flutter/material.dart';
import 'package:flutter_gauges/domain/gauge_values_notifier.dart';

import 'gauge_display_alerts.dart';

class GaugeDisplayWrapper extends StatelessWidget {
  final GaugeValuesNotifiers notifiers;
  final Widget child;

  const GaugeDisplayWrapper({
    super.key,
    required this.notifiers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: Stack(
        children: [
          Material(child: child),
          IgnorePointer(
            ignoring: true,
            child: GaugeDisplayAlerts(notifiers: notifiers),
          ),
        ],
      ),
    );
  }
}
