import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_ai/loading.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock Firebase Platform
class MockFirebasePlatform extends FirebasePlatform {
  final Map<String, MockFirebaseAppPlatform> _apps = {};

  @override
  bool get isAutoInitEnabled => true;

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    name ??= defaultFirebaseAppName;
    final app = MockFirebaseAppPlatform(
      options: options ??
          const FirebaseOptions(
            apiKey: 'mock-api-key',
            appId: 'mock-app-id',
            messagingSenderId: 'mock-sender-id',
            projectId: 'mock-project-id',
          ),
    );
    _apps[name] = app;
    return app;
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    if (_apps.containsKey(name)) {
      return _apps[name]!;
    }

    throw FirebaseException(
      plugin: 'core',
      message: 'No Firebase App \'$name\' has been created - '
          'call Firebase.initializeApp() first',
    );
  }
}

class MockFirebaseAppPlatform extends FirebaseAppPlatform {
  MockFirebaseAppPlatform({required FirebaseOptions options}) : super('[DEFAULT]', options);
}

// Mock cho Remote Config Platform Interface
class MockFirebaseRemoteConfigPlatform extends FirebaseRemoteConfigPlatform {
  static Map<String, RemoteConfigValue> _configValues = {
    'banner_all': RemoteConfigValue(
      utf8.encode('false'),
      ValueSource.valueRemote,
    ),
    'inter_knowledge_detail': RemoteConfigValue(
      utf8.encode('false'),
      ValueSource.valueRemote,
    ),
    'open_resume': RemoteConfigValue(
      utf8.encode('false'),
      ValueSource.valueRemote,
    ),
    'inter_create_prompt': RemoteConfigValue(
      utf8.encode('false'),
      ValueSource.valueRemote,
    ),
  };

  @override
  FirebaseRemoteConfigPlatform setInitialValues({
    required Map<dynamic, dynamic> remoteConfigValues,
  }) {
    _configValues = remoteConfigValues.map(
      (key, value) {
        return MapEntry(key.toString(), RemoteConfigValue(utf8.encode(value.toString()), ValueSource.valueRemote));
      },
    );
    return this;
  }

  MockFirebaseRemoteConfigPlatform() : super();

  @override
  FirebaseRemoteConfigPlatform delegateFor({required FirebaseApp app}) {
    return this;
  }

  @override
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {}

  @override
  Future<bool> fetchAndActivate() async => true;

  @override
  bool getBool(String key) => _configValues[key]?.asString() == 'true';

  @override
  Map<String, RemoteConfigValue> getAll() => _configValues;

  // Implement setInitialValues to avoid the UnimplementedError
}

void setupMockRemoteConfig() {
  // Thiết lập instance cho RemoteConfig Platform
  FirebaseRemoteConfigPlatform.instance = MockFirebaseRemoteConfigPlatform();

  // Vẫn giữ lại mock cho method channel nhưng thêm initialValue
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_remote_config'),
    (MethodCall methodCall) async {
      print('MockRemoteConfig: ${methodCall.method}');
      switch (methodCall.method) {
        case 'RemoteConfig#fetchAndActivate':
          return true;
        case 'RemoteConfig#setConfigSettings':
          return null;
        case 'RemoteConfig#getValue':
          return {
            'source': 'remote',
            'value': 'true',
            'valueType': 'boolean',
          };
        case 'RemoteConfig#getBool':
          return true;
        case 'RemoteConfig#getAll':
          return {
            'banner_all': {
              'source': 'remote',
              'value': 'false',
              'valueType': 'boolean',
            },
            'inter_knowledge_detail': {
              'source': 'remote',
              'value': 'false',
              'valueType': 'boolean',
            },
            'open_resume': {
              'source': 'remote',
              'value': 'false',
              'valueType': 'boolean',
            },
            'inter_create_prompt': {
              'source': 'remote',
              'value': 'false',
              'valueType': 'boolean',
            },
          };
        case 'RemoteConfig#setInitialValues':
          return null;
        default:
          return null;
      }
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Setup Firebase Core mock
    FirebasePlatform.instance = MockFirebasePlatform();

    // Setup Remote Config mock
    print('Setup Remote Config mock');
    setupMockRemoteConfig();

    // Initialize Firebase
    print('Initialize Firebase');
    await Firebase.initializeApp();

    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    await setupLocator();
    setupEasyLoading();

    const MethodChannel sensorChannel = MethodChannel('dev.fluttercommunity.plus/sensors/method');
    sensorChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'setAccelerationSamplingPeriod') {
        return null;
      }
      throw MissingPluginException('No implementation found for method ${methodCall.method}');
    });
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_remote_config'),
      null,
    );
  });

  testWidgets('App builds successfully without exceptions', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('vi')],
          path: 'assets/langs',
          useOnlyLangCode: true,
          fallbackLocale: const Locale('en'),
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => const Main(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Main), findsOneWidget);
    });
  });
}
