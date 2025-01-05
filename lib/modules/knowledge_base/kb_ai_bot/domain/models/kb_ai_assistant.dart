// "openAiAssistantId": "asst_cgaHN0ZT8Dh6w1Fnzs80T8Qr",
// "userId": "5a0e07dd-d7d8-4071-b2af-c7e04da5b543",
// "assistantName": "Jarvis Bot",
// "instructions": "You are an assistant of the Jarvis system ...",
// "description": "This bot is used to ask about the Jarvis system",
// "openAiThreadIdPlay": "thread_BrdOEFlUzdgHxtSCDAiFe8lL",
// "openAiVectorStoreId": "vs_rN4CEY8dIbdLyvbUjE8w4QQQ",
// "isDefault": false,
// "createdBy": null,
// "updatedBy": null,
// "isFavorite": false,
// "createdAt": "2024-12-20T18:27:41.177Z",
// "updatedAt": "2024-12-20T18:27:41.177Z",
// "deletedAt": null,
// "id": "2cdf8ca1-cd90-420f-a493-50baf4285bf9"

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kb_ai_assistant.g.dart';

@JsonSerializable()
@CopyWith()
class KBAIAssistant extends Equatable {
  @JsonKey(name: 'openAiAssistantId')
  final String openAiAssistantId;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'assistantName')
  final String assistantName;
  @JsonKey(name: 'instructions')
  final String? instructions;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'openAiThreadIdPlay')
  final String openAiThreadIdPlay;
  @JsonKey(name: 'openAiVectorStoreId')
  final String openAiVectorStoreId;
  @JsonKey(name: 'isDefault')
  final bool isDefault;
  @JsonKey(name: 'createdBy')
  final dynamic createdBy;
  @JsonKey(name: 'updatedBy')
  final dynamic updatedBy;
  @JsonKey(name: 'isFavorite')
  final bool isFavorite;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @JsonKey(name: 'deletedAt')
  final dynamic deletedAt;
  @JsonKey(name: 'id')
  final String id;

  const KBAIAssistant({
    required this.openAiAssistantId,
    required this.userId,
    required this.assistantName,
    required this.instructions,
    required this.description,
    required this.openAiThreadIdPlay,
    required this.openAiVectorStoreId,
    required this.isDefault,
    required this.createdBy,
    required this.updatedBy,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.id,
  });

  @override
  List<Object?> get props => [id, updatedAt];

  factory KBAIAssistant.fromJson(Map<String, dynamic> json) => _$KBAIAssistantFromJson(json);
  Map<String, dynamic> toJson() => _$KBAIAssistantToJson(this);
}
