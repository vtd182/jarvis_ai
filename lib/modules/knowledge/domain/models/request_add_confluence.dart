import 'package:json_annotation/json_annotation.dart';

part 'request_add_confluence.g.dart';

@JsonSerializable()
class RequestAddConfluence {
  final String unitName;
  final String wikiPageUrl;
  final String confluenceUsername;
  final String confluenceAccessToken;

  RequestAddConfluence({
    required this.unitName,
    required this.wikiPageUrl,
    required this.confluenceUsername,
    required this.confluenceAccessToken,
  });

  factory RequestAddConfluence.fromJson(Map<String, dynamic> json) => _$RequestAddConfluenceFromJson(json);

  Map<String, dynamic> toJson() => _$RequestAddConfluenceToJson(this);
}
