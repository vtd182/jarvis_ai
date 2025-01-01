import 'package:json_annotation/json_annotation.dart';

part 'request_create_kl.g.dart';

@JsonSerializable()
class RequestCreateKl {
  String knowledgeName;

  String? description;

  RequestCreateKl({required this.knowledgeName, this.description});

  factory RequestCreateKl.fromJson(Map<String, dynamic> json) => _$RequestCreateKlFromJson(json);

  Map<String, dynamic> toJson() => _$RequestCreateKlToJson(this);
}
