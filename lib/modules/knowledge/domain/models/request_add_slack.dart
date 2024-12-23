import 'package:json_annotation/json_annotation.dart';

part 'request_add_slack.g.dart';

@JsonSerializable()
class RequestAddSlack {
  final String unitName;
  final String slackWorkspace;
  final String slackBotToken;

  RequestAddSlack({
    required this.unitName,
    required this.slackWorkspace,
    required this.slackBotToken,
  });

  factory RequestAddSlack.fromJson(Map<String, dynamic> json) =>
      _$RequestAddSlackFromJson(json);

  Map<String, dynamic> toJson() => _$RequestAddSlackToJson(this);
}
