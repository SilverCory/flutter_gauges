import 'package:flutter/material.dart';
import 'package:flutter_gauges/domain/gauge_values_notifier.dart';
import 'package:icons_flutter/icons_flutter.dart';

class GaugeDisplayAlerts extends StatefulWidget {
  final GaugeValuesNotifiers notifiers;

  const GaugeDisplayAlerts({
    super.key,
    required this.notifiers,
  });

  @override
  State<StatefulWidget> createState() {
    return _GaugeDisplayAlerts();
  }
}

class _GaugeDisplayAlerts extends State<GaugeDisplayAlerts> {
  Color colorKnocked = Colors.transparent;
  Color colorTwoStep = Colors.grey.withOpacity(0.2);
  Color colorOilPressure = Colors.red;
  Color colorCoolantTemperature = Colors.blue;

  void _updateOilLight() {
    setState(() {
      colorOilPressure = widget.notifiers.oilLight.value
          ? Colors.red
          : Colors.green.withOpacity(0.2);
    });
  }

  void _updateKnocked() {
    setState(() {
      colorKnocked =
          widget.notifiers.knocked.value ? Colors.red : Colors.transparent;
    });
  }

  void _updateTwoStep() {
    setState(() {
      colorTwoStep = widget.notifiers.twoStep.value
          ? Colors.orange
          : Colors.grey.withOpacity(0.2);
    });
  }

  void _updateCoolantTemperature() {
    setState(() {
      colorCoolantTemperature = widget.notifiers.coolantTempColour.value;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.notifiers.oilLight.addListener(_updateOilLight);
    widget.notifiers.knocked.addListener(_updateKnocked);
    widget.notifiers.twoStep.addListener(_updateTwoStep);
    widget.notifiers.coolantTempColour.addListener(_updateCoolantTemperature);
  }

  @override
  void dispose() {
    widget.notifiers.oilLight.removeListener(_updateOilLight);
    widget.notifiers.knocked.removeListener(_updateKnocked);
    widget.notifiers.twoStep.removeListener(_updateTwoStep);
    widget.notifiers.coolantTempColour
        .removeListener(_updateCoolantTemperature);

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
        border: Border.all(
          color: colorKnocked,
          width: 18.0,
        ),
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
                    // color: twoStep ? Colors.orange : Colors.grey.withOpacity(0.2),
                    color: colorTwoStep,
                  ),
                  Icon(
                    FontAwesome.thermometer_half,
                    color: colorCoolantTemperature,
                  ),
                  Icon(
                    FontAwesome5Icon.oil_can,
                    // color: oilPressure ? Colors.red : Colors.green.withOpacity(0.2),
                    color: colorOilPressure,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
