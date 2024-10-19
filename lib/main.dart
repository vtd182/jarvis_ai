import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_ai/modules/app.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await initSystem();


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

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    if (systemOverlaysAreVisible) {
      await Future.delayed(const Duration(seconds: 3));
      SystemChrome.restoreSystemUIOverlays();
    }
  });
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}