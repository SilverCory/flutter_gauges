import 'package:json_annotation/json_annotation.dart';

part 'gauge_values.g.dart';

@JsonSerializable()
class GaugeValues {
  final double afrValue;
  final double afrTarget;
  final double intakePressure;
  final bool knocked;
  final bool twoStep;
  final double waterTemperature;
  final double oilPressure;

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

  factory GaugeValues.fromJson(Map<String, dynamic> json) =>
      _$GaugeValuesFromJson(json);

  Map<String, dynamic> toJson() => _$GaugeValuesToJson(this);
}
