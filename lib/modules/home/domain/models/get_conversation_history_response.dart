import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:jarvis_ai/modules/home/domain/enums/assistant.dart';
import 'package:jarvis_ai/modules/home/domain/models/assistant_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversation_history_item_model.dart';
import 'message_model.dart';

part 'get_conversation_history_response.g.dart';

@JsonSerializable()
@CopyWith()
class GetConversationsHistoryResponse {
  @JsonKey(name: "cursor")
  String cursor;

  @JsonKey(name: "has_more")
  bool hasMore;

  @JsonKey(name: "limit")
  int limit;

  @JsonKey(name: "items")
  List<ConversationHistoryItemModel> items;
  GetConversationsHistoryResponse({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  factory GetConversationsHistoryResponse.fromJson(Map<String, dynamic> json) => _$GetConversationsHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetConversationsHistoryResponseToJson(this);
}

extension GetConversationsHistoryResponseExtension on GetConversationsHistoryResponse {
  List<MessageModel> toMessageModels() {
    List<MessageModel> messages = [];
    for (final item in items) {
      final userMessage = MessageModel(
        role: "user",
        content: item.query,
        assistant: AssistantModel(
          id: Assistant.gpt_4o_mini,
          model: "dify",
          name: Assistant.gpt_4o_mini.label,
        ),
        isErrored: false,
      );
      final assistantMessage = MessageModel(
        role: "model",
        content: item.answer,
        assistant: AssistantModel(
          id: Assistant.gpt_4o_mini,
          model: "dify",
          name: Assistant.gpt_4o_mini.label,
        ),
        isErrored: false,
      );
      messages.add(userMessage);
      messages.add(assistantMessage);
    }
    return messages;
  } // ignore: avoid_redundant_argument_values>
}
