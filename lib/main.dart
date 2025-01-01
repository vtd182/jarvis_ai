import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jarvis_ai/ads/ad_id_manager.dart';
import 'package:jarvis_ai/helpers/utils.dart' as utils;

import 'loading.dart';
import 'locator.dart';
import 'modules/connection/app/ui/connection_page.dart';
import 'modules/onboarding/app/ui/splash/splash_page.dart';

AppAdIdManager adIdManager = AppAdIdManager();

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await _initFirebaseSDK();
      await setupLocator();
      setupEasyLoading();
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

_initFirebaseSDK() async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MyAppState();
}

class _MyAppState extends State<Main> with WidgetsBindingObserver {
  StreamSubscription? _streamSubscription;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _streamSubscription = EasyAds.instance.onEvent.listen((event) {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isPaused) {
        isPaused = false;

        EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(false);
      }
    } else if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    super.didChangeAppLifecycleState(state);
  }

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
            cursorColor: Colors.blue,
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
            return const SplashPage();
          },
        ),
      ),
    );
  }
}
