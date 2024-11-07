import 'dart:io';

import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:jarvis_ai/extensions/string_ext.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:jarvis_ai/locale_keys.g.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/retrofit/rest_error.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:shake/shake.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class RestClient {
  static final BaseOptions _options = BaseOptions(
    baseUrl: Config.baseUrl,
    connectTimeout: const Duration(milliseconds: Config.connectTimeout),
    receiveTimeout: const Duration(milliseconds: Config.receiveTimeout),
  );

  Dio dio = Dio(_options);

  bool onRefreshToken = false;
  bool onRefreshLockerToken = false;

  Future<Unit> _configDioInterceptors() async {
    if (Config.aliceEnable) {
      dio.interceptors.add(locator<Alice>().getDioInterceptor());
      ShakeDetector.autoStart(onPhoneShake: () {
        locator<Alice>().showInspector();
      });
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          var token = await SPref.instance.getAccessToken();
          // todo: check login
          options.headers["Authorization"] = "Bearer $token";
          options.headers["Accept"] = "application/json";
          options.headers["X-Language"] = await SPref.instance.getLanguage() ?? Platform.localeName.substring(0, 2);
          handler.next(options);
        },
        onResponse: (e, handler) async {
          if (e.data is Map<String, dynamic>) {
            final data = e.data as Map<String, dynamic>;
            if (data.containsKey("data") && data.containsKey("meta")) {
              e.data = data["data"];
            }
          }
          handler.next(e);
        },
        onError: (e, handler) async {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              return handler.next(RestError.fromErrorString(LocaleKeys.shared_network_problem.trans(), null));
            case DioExceptionType.badResponse:
              if (e.response != null) {
                if (e.response!.statusCode == HttpStatus.unauthorized) {
                  showToast("Session expired");
                }
                if (e.response!.statusCode == HttpStatus.tooManyRequests) {
                  return handler.next(RestError.fromErrorString("Too many requests", e.response!.headers));
                }
                if (e.response!.data != null) {
                  return handler.next(RestError.fromJson(e.response!.data, e.response!.headers));
                }
                return handler.next(RestError.fromErrorString(e.message, e.response!.headers));
              }
              return handler.next(RestError.fromErrorString(e.message, null));
            case DioExceptionType.connectionError:
              return handler.next(RestError.fromErrorString(LocaleKeys.shared_problem_connecting_server.trans(), null));
            case DioExceptionType.cancel:
            default:
              return handler.next(RestError.fromErrorString(LocaleKeys.shared_problem_connecting_server.trans(), null));
          }
        },
      ),
    );
    return unit;
  }

  RestClient() {
    _configDioInterceptors();
  }
}
