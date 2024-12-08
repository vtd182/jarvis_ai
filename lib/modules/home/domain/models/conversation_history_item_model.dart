// "answer": "Hello! It's nice to meet you. I'm Jarvis, an AI assistant created by Anthropic. I'm here to help with any questions or tasks you might have. How can I assist you today?",
// "createdAt": 1730480206,
// "files": [],
// "query": "hi"

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_history_item_model.g.dart';

@CopyWith()
@JsonSerializable()
class ConversationHistoryItemModel {
  @JsonKey(name: "answer")
  final String answer;
  @JsonKey(name: "createdAt")
  final int createdAt;
  @JsonKey(name: "files")
  final List<String> files;
  @JsonKey(name: "query")
  final String query;

  ConversationHistoryItemModel({
    required this.answer,
    required this.createdAt,
    required this.files,
    required this.query,
  });

  factory ConversationHistoryItemModel.fromJson(Map<String, dynamic> json) => _$ConversationHistoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationHistoryItemModelToJson(this);
}
