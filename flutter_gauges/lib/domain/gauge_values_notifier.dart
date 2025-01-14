import 'package:flutter/material.dart';
import 'package:flutter_gauges/domain/gauge_values.dart';

class GaugeValuesNotifiers {
  final ValueNotifier<double> afrValue = ValueNotifier(0);
  final ValueNotifier<double> afrTarget = ValueNotifier(0);
  final ValueNotifier<double> intakePressure = ValueNotifier(0);
  final ValueNotifier<bool> knocked = ValueNotifier(false);
  final ValueNotifier<bool> twoStep = ValueNotifier(false);
  final ValueNotifier<double> waterTemperature = ValueNotifier(0);
  final ValueNotifier<double> oilPressure = ValueNotifier(0);

  // Fields not reflected
  final ValueNotifier<bool> oilLight = ValueNotifier(true);
  final ValueNotifier<Color> coolantTempColour = ValueNotifier(Colors.blue);

  void dispose() {
    afrValue.dispose();
    afrTarget.dispose();
    intakePressure.dispose();
    knocked.dispose();
    twoStep.dispose();
    waterTemperature.dispose();
    oilPressure.dispose();

    oilLight.dispose();
    coolantTempColour.dispose();
  }

  void imposeValues(GaugeValues newValues) {
    afrValue.value = newValues.afrValue;
    afrTarget.value = newValues.afrTarget;
    intakePressure.value = newValues.intakePressure;
    knocked.value = newValues.knocked;
    twoStep.value = newValues.twoStep;
    waterTemperature.value = newValues.waterTemperature;
    oilPressure.value = newValues.oilPressure;
    _calculateOilPressureLight(newValues.oilPressure);
    _calculateCoolantColour(newValues.waterTemperature);
  }

  void _calculateCoolantColour(double coolantTemperature) {
    Color color = Colors.green.withOpacity(0.2);
    if (coolantTemperature < 60) {
      color = Colors.blue;
    }
    if (coolantTemperature > 110) {
      color = Colors.red;
    }

    coolantTempColour.value = color;
  }

  void _calculateOilPressureLight(double oilPressure) {
    oilLight.value = oilPressure < 100;
  }
}
