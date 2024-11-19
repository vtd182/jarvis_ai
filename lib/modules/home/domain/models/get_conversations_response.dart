import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversation_summary_model.dart';

part 'get_conversations_response.g.dart';

@JsonSerializable()
@CopyWith()
class GetConversationsResponse {
  @JsonKey(name: "cursor")
  String cursor;

  @JsonKey(name: "has_more")
  bool hasMore;

  @JsonKey(name: "limit")
  int limit;

  @JsonKey(name: "items")
  List<ConversationSummaryModel> items;
  GetConversationsResponse({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  factory GetConversationsResponse.fromJson(Map<String, dynamic> json) => _$GetConversationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetConversationsResponseToJson(this);
}
