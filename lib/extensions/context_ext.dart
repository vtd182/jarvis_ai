import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  void hideKeyboard() {
    final FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
