import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/config.dart';

class RestError extends DioException {
  static String defaultErrorMessage = "Have a error, please try again later";
  List<String>? _errors;
  Headers? _headers;

  RestError(this._errors, this._headers) : super(requestOptions: RequestOptions(path: Config.baseUrl));

  factory RestError.fromJson(dynamic map, Headers? headers) {
    final List<String> allMessages = [];

    if (map is String) {
      try {
        final mapErr = jsonDecode(map);
        if (mapErr is Map<String, dynamic>) {
          if (mapErr.containsKey("message") && mapErr["message"] != null) {
            if (mapErr.containsKey("details") && mapErr["details"] is List<dynamic>) {
              for (final detail in mapErr["details"]) {
                allMessages.add(detail["issue"].toString());
              }
            }
          }
          return RestError(allMessages, headers);
        }
      } catch (e) {
        allMessages.add(map);
        return RestError(allMessages, headers);
      }
    } else if (map is Map<String, dynamic>) {
      if (map.containsKey("message") && map["message"] != null) {
        if (map.containsKey("details") && map["details"] is List<dynamic>) {
          for (final detail in map["details"]) {
            allMessages.add(detail["issue"].toString());
          }
        }
      }
    }

    // Nếu map chứa key "message", thêm giá trị của message vào allMessages
    if ((map as Map<String, dynamic>).containsKey("message") && map["message"] != null) {
      allMessages.add(map["message"].toString());
    }

    // Nếu map chứa key "details" và "details" là danh sách, thêm các giá trị vào allMessages
    if (map.containsKey("details") && map["details"] is List<dynamic>) {
      for (final detail in map["details"]) {
        allMessages.add(detail.toString());
      }
    }

    // Nếu không có message hoặc details, sử dụng thông báo lỗi mặc định
    if (allMessages.isEmpty) {
      allMessages.add(defaultErrorMessage);
    }

    return RestError(allMessages, headers);
  }

  factory RestError.fromErrorString(String? error, Headers? headers) {
    return RestError([error ?? defaultErrorMessage], headers);
  }

  List<String> getErrors() {
    return _errors != null ? _errors! : [];
  }

  String getAllErrorWithString() {
    return getErrors().join(", ");
  }

  String getError() {
    return getErrors().first;
  }

  String? getHeader(String key) => _headers?.value(key);
}
