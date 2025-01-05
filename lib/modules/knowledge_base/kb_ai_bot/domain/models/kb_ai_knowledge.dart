import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kb_ai_knowledge.g.dart';

@JsonSerializable()
@CopyWith()
class KBAIKnowledge extends Equatable {
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @JsonKey(name: 'createdBy')
  final dynamic createdBy;
  @JsonKey(name: 'updatedBy')
  final dynamic updatedBy;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'knowledgeName')
  final String knowledgeName;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'numUnits')
  final int numUnits;
  @JsonKey(name: 'totalSize')
  final double totalSize;

  const KBAIKnowledge({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.userId,
    required this.knowledgeName,
    required this.description,
    required this.id,
    required this.numUnits,
    required this.totalSize,
  });

  @override
  List<Object?> get props => [id, createdAt, updatedAt];

  factory KBAIKnowledge.fromJson(Map<String, dynamic> json) => _$KBAIKnowledgeFromJson(json);
  Map<String, dynamic> toJson() => _$KBAIKnowledgeToJson(this);
}
