import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_reply_response_model.g.dart';

@JsonSerializable()
@CopyWith()
class EmailReplyResponse {
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "remainingUsage")
  int remainingUsage;
  EmailReplyResponse({
    required this.email,
    required this.remainingUsage,
  });

  factory EmailReplyResponse.fromJson(Map<String, dynamic> json) => _$EmailReplyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailReplyResponseToJson(this);
}
