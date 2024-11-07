import 'package:json_annotation/json_annotation.dart';

class StringConverter implements JsonConverter<String, dynamic> {
  const StringConverter();

  @override
  String fromJson(dynamic json) {
    if (json is num) return json.toString();
    if (json is String) return json;
    return '';
  }

  @override
  String toJson(String object) {
    return object;
  }
}
