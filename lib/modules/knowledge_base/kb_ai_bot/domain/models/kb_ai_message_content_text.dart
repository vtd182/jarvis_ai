import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kb_ai_message_content.g.dart';

@JsonSerializable()
@CopyWith()
class KBAIMessageContent {
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'content')
  final String content;

  const KBAIMessageContent({
    required this.createdAt,
    required this.role,
    required this.content,
  });

  factory KBAIMessage.fromJson(Map<String, dynamic> json) => _$KBAIMessageFromJson(json);
  Map<String, dynamic> toJson() => _$KBAIMessageToJson(this);
}


