import 'package:json_annotation/json_annotation.dart';

part 'request_add_url.g.dart';

@JsonSerializable()
class RequestAddUrl {
  final String unitName;
  final String webUrl;

  RequestAddUrl({required this.unitName, required this.webUrl});

  factory RequestAddUrl.fromJson(Map<String, dynamic> json) =>
      _$RequestAddUrlFromJson(json);
  Map<String, dynamic> toJson() => _$RequestAddUrlToJson(this);
}
