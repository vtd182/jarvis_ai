import 'package:json_annotation/json_annotation.dart';

part 'response_create_kl.g.dart';

@JsonSerializable()
class ResponseCreateKl {
  String createdAt;

  String? updatedAt;

  String? createdBy;

  String? updatedBy;

  String userId;

  String knowledgeName;

  String description;

  ResponseCreateKl(
      {required this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      required this.userId,
      required this.knowledgeName,
      required this.description});

  factory ResponseCreateKl.fromJson(Map<String, dynamic> json) => _$ResponseCreateKlFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseCreateKlToJson(this);
}
