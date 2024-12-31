import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kb_ai_message_content.dart';

part 'kb_ai_message.g.dart';

@JsonSerializable()
@CopyWith()
class KBAIMessage extends Equatable {
  // format of the date is 173599... with 6 digits after the dot
  @JsonKey(name: 'createdAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'content')
  final List<KBAIMessageContent> content;

  const KBAIMessage({
    required this.createdAt,
    required this.role,
    required this.content,
  });

  @override
  List<Object?> get props => [createdAt, role, content];

  factory KBAIMessage.fromJson(Map<String, dynamic> json) => _$KBAIMessageFromJson(json);
  Map<String, dynamic> toJson() => _$KBAIMessageToJson(this);
}

DateTime _dateTimeFromJson(int date) {
  return DateTime.fromMillisecondsSinceEpoch(date);
}

String _dateTimeToJson(DateTime date) {
  return date.millisecondsSinceEpoch.toString();
}
