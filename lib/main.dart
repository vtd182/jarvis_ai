import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/app.dart';
import 'package:jarvis_ai/modules/subscribe/presentation/controller/subscribe_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initSystem();

  initDi();

  runApp(const App());
}

Future<void> initSystem() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      systemStatusBarContrastEnforced: true,
    ),
  );

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    if (systemOverlaysAreVisible) {
      await Future.delayed(const Duration(seconds: 3));
      SystemChrome.restoreSystemUIOverlays();
    }
  });
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

void initDi(){
  Get.put(SubscribeController(), permanent: true);
}
