import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kb_ai_thread.g.dart';

// "createdAt": "2024-12-20T18:54:18.839Z",
// "updatedAt": "2024-12-20T18:54:18.839Z",
// "createdBy": null,
// "updatedBy": null,
// "deletedAt": null,
// "id": "f392314c-2806-4ffc-8101-73a4bf3ff6e5",
// "openAiThreadId": "thread_g6y2ywYT06zoR7hUKKDtWQMZ",
// "threadName": "Chatting Etiquette",
// "assistantId": "2cdf8ca1-cd90-420f-a493-50baf4285bf9",
// "integratedPlatform": null,
// "usedUserId": null

@JsonSerializable()
@CopyWith()
class KBAIThread extends Equatable {
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @JsonKey(name: 'createdBy')
  final dynamic createdBy;
  @JsonKey(name: 'updatedBy')
  final dynamic updatedBy;
  @JsonKey(name: 'deletedAt')
  final dynamic deletedAt;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'openAiThreadId')
  final String openAiThreadId;
  @JsonKey(name: 'threadName')
  final String threadName;
  @JsonKey(name: 'assistantId')
  final String assistantId;
  @JsonKey(name: 'integratedPlatform')
  final dynamic integratedPlatform;
  @JsonKey(name: 'usedUserId')
  final dynamic usedUserId;

  const KBAIThread({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedAt,
    required this.id,
    required this.openAiThreadId,
    required this.threadName,
    required this.assistantId,
    required this.integratedPlatform,
    required this.usedUserId,
  });

  @override
  List<Object?> get props => [id, createdAt];

  factory KBAIThread.fromJson(Map<String, dynamic> json) => _$KBAIThreadFromJson(json);
  Map<String, dynamic> toJson() => _$KBAIThreadToJson(this);
}
