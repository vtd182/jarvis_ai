import 'package:json_annotation/json_annotation.dart';

part 'response_get_kl.g.dart';

@JsonSerializable()
class ResponseGetKl {
  String createdAt;

  String? updatedAt;

  String? createdBy;

  String? updatedBy;

  String id;

  String userId;

  String knowledgeName;

  String description;

  int numUnits;

  double totalSize;

  ResponseGetKl(
      {required this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      required this.id,
      required this.userId,
      required this.knowledgeName,
      required this.description,
      required this.numUnits,
      required this.totalSize});

  factory ResponseGetKl.fromJson(Map<String, dynamic> json) =>
      _$ResponseGetKlFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseGetKlToJson(this);
}
