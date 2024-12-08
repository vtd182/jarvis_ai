import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_chat_response.g.dart';

// response of Send Message API
@JsonSerializable()
@CopyWith()
class AIChatResponse {
  @JsonKey(name: 'conversationId')
  String conversationId;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'remainingUsage')
  int remainingUsage;

  AIChatResponse({required this.conversationId, required this.message, required this.remainingUsage});
  @override
  List<Object?> get props => [conversationId, message, remainingUsage];
  factory AIChatResponse.fromJson(Map<String, dynamic> json) => _$AIChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AIChatResponseToJson(this);
}
