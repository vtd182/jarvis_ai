import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jarvis_ai/helpers/utils.dart' as utils;
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page.dart';

import 'loading.dart';
import 'locator.dart';
import 'modules/connection/app/ui/connection_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  setupEasyLoading();
  await runZonedGuarded(
    () async {
      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('vi')],
          path: 'assets/langs',
          useOnlyLangCode: true,
          fallbackLocale: const Locale('en'),
          child: const Main(),
        ),
      );
    },
    // record error in firebase crashlytics
    (error, stackTrace) {
      print(error);
    },
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MyAppState();
}

class _MyAppState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        themeMode: ThemeMode.light,
        title: 'Jarvis AI',
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.orange,
          ),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ).copyWith(
            primary: Colors.blue,
            onPrimary: Colors.white,
            secondary: Colors.green,
          ),
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
            child: FlutterEasyLoading(child: child),
          );
        },
        home: LayoutBuilder(
          builder: (context, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) => utils.insertOverlay(context, const ConnectionPage()));
            return const LoginPage();
          },
        ),
      ),
    );
  }
}

// homepage
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
