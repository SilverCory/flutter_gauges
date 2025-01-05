import 'package:json_annotation/json_annotation.dart';

part 'gauge_values.g.dart';

@JsonSerializable()
class GaugeValues {
  final double afrValue;
  final double afrTarget;
  final double intakePressure;
  final bool knocked;

  GaugeValues({
    required this.afrValue,
    required this.afrTarget,
    required this.intakePressure,
    required this.knocked,
  });

  GaugeValues.zero({
    this.afrValue = 0,
    this.afrTarget = 0,
    this.intakePressure = 0,
    this.knocked = false,
  });

  factory GaugeValues.fromJson(Map<String, dynamic> json) =>
      _$GaugeValuesFromJson(json);

  Map<String, dynamic> toJson() => _$GaugeValuesToJson(this);
}
