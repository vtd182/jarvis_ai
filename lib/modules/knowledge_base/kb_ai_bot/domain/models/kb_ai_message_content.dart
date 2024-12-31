import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kb_ai_message_content_text.dart';

part 'kb_ai_message_content.g.dart';

@JsonSerializable()
@CopyWith()
class KBAIMessageContent {
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'text')
  final KBAIMessageContentText text;

  const KBAIMessageContent({
    required this.type,
    required this.text,
  });

  factory KBAIMessageContent.fromJson(Map<String, dynamic> json) => _$KBAIMessageContentFromJson(json);
  Map<String, dynamic> toJson() => _$KBAIMessageContentToJson(this);
}
