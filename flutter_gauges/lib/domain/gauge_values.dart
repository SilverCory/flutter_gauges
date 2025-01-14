import 'package:json_annotation/json_annotation.dart';

part 'gauge_values.g.dart';

@JsonSerializable(createToJson: false, createFactory: true)
class GaugeValues {
  double afrValue;
  double afrTarget;
  double intakePressure;
  bool knocked;
  bool twoStep;
  double waterTemperature;
  double oilPressure;

  GaugeValues({
    required this.afrValue,
    required this.afrTarget,
    required this.intakePressure,
    required this.knocked,
    required this.twoStep,
    required this.waterTemperature,
    required this.oilPressure,
  });

  GaugeValues.zero({
    this.afrValue = 0,
    this.afrTarget = 0,
    this.intakePressure = 0,
    this.knocked = false,
    this.twoStep = false,
    this.waterTemperature = 0,
    this.oilPressure = 0,
  });

  void fromJson(Map<String, dynamic> json) {
    afrValue = (json['afrValue'] as num).toDouble();
    afrTarget = (json['afrTarget'] as num).toDouble();
    intakePressure = (json['intakePressure'] as num).toDouble();
    knocked = json['knocked'] as bool;
    twoStep = json['twoStep'] as bool;
    waterTemperature = (json['waterTemperature'] as num).toDouble();
    oilPressure = (json['oilPressure'] as num).toDouble();
  }

  factory GaugeValues.fromJson(Map<String, dynamic> json) =>
      _$GaugeValuesFromJson(json);
}
