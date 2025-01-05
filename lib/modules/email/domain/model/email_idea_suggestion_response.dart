import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_idea_suggestion_response.g.dart';

@JsonSerializable()
@CopyWith()
class EmailIdeaSuggestionResponse {
  @JsonKey(name: "ideas")
  List<String> ideas;
  EmailIdeaSuggestionResponse({
    required this.ideas,
  });

  factory EmailIdeaSuggestionResponse.fromJson(Map<String, dynamic> json) => _$EmailIdeaSuggestionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailIdeaSuggestionResponseToJson(this);
}
