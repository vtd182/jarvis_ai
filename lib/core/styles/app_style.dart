import 'package:flutter/material.dart';

class AppStyle {
  static TextStyle regularStyle({
    double fontSize = 14,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle boldStyle({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
