import 'package:json_annotation/json_annotation.dart';

part 'response_get_unit.g.dart';

@JsonSerializable()
class ResponseGetUnit {
  String createdAt;

  String? updatedAt;

  String? createdBy;

  String? updatedBy;

  String id;

  String name;

  bool status;

  String userId;

  String knowledgeId;

  String type;

  ResponseGetUnit(
      {required this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      required this.id,
      required this.name,
      required this.status,
      required this.userId,
      required this.knowledgeId,
      required this.type});

  factory ResponseGetUnit.fromJson(Map<String, dynamic> json) => _$ResponseGetUnitFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseGetUnitToJson(this);
}
