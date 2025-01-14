import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gauges/display/gauge_display.dart';
import 'package:json_theme_plus/json_theme_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    title: 'Flutter Gauges',
    theme: theme,
    home: SharedAppData(
      child: GaugeDisplay(prefs: prefs),
    ),
  ));
}
