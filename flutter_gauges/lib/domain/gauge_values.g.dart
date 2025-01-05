// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gauge_values.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GaugeValues _$GaugeValuesFromJson(Map<String, dynamic> json) => GaugeValues(
      afrValue: (json['afrValue'] as num).toDouble(),
      afrTarget: (json['afrTarget'] as num).toDouble(),
      intakePressure: (json['intakePressure'] as num).toDouble(),
      knocked: json['knocked'] as bool,
    );

Map<String, dynamic> _$GaugeValuesToJson(GaugeValues instance) =>
    <String, dynamic>{
      'afrValue': instance.afrValue,
      'afrTarget': instance.afrTarget,
      'intakePressure': instance.intakePressure,
      'knocked': instance.knocked,
    };
