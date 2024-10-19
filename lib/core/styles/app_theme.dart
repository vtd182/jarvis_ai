import 'package:flutter/material.dart';

class AppTheme {
  
  /// LIGHT ===================================================
  static final lightTheme = ThemeData(
    textTheme: ThemeData.light().textTheme,
    scaffoldBackgroundColor: Colors.white,
    listTileTheme: const ListTileThemeData(
      textColor: Colors.black,
    ),
  );
}