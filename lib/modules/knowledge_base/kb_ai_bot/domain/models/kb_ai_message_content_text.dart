import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kb_ai_message_content_text.g.dart';

@JsonSerializable()
@CopyWith()
class KBAIMessageContentText {
  @JsonKey(name: 'value')
  final String value;
  @JsonKey(name: 'annotations')
  final List<dynamic> annotations;
  KBAIMessageContentText(this.annotations, this.value);

  factory KBAIMessageContentText.fromJson(Map<String, dynamic> json) => _$KBAIMessageContentTextFromJson(json);
  Map<String, dynamic> toJson() => _$KBAIMessageContentTextToJson(this);
}
