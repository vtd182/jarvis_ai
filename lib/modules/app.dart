import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/routes/app_route.dart';
import 'package:jarvis_ai/core/styles/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      theme: AppTheme.lightTheme,

      debugShowCheckedModeBanner: false,
      
      getPages: AppRoute.listPages,
      initialRoute: AppRoute.chatRoute,
    );
  }
}