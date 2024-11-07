import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void setupEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..userInteractions = false
    ..indicatorColor = Colors.amber
    ..textColor = Colors.black;
}
