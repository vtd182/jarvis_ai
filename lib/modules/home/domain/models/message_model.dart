// {
// "role": "user",
// "content": "hi",
// "assistant": {
// "id": "gpt-4o-mini",
// "model": "dify",
// "name": "GPT-4o mini"
// }
// }

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'assistant_model.dart';

part 'message_model.g.dart';

@CopyWith()
@JsonSerializable()
class MessageModel {
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'assistant')
  final AssistantModel assistant;
  @JsonKey(name: "isErrored")
  bool? isErrored = false;
  MessageModel({
    required this.role,
    required this.content,
    required this.assistant,
    this.isErrored,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
