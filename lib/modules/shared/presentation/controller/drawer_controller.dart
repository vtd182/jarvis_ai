import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawerController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var indexHistorySelected = (-1).obs;
  var indexFunctionSelected = ("").obs;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
