import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversation_history_item_model.dart';

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
