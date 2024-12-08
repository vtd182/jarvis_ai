import 'package:json_annotation/json_annotation.dart';

part 'conversation_summary_model.g.dart';

@JsonSerializable()
class ConversationSummaryModel {
  final String id;
  final String title;
  final int createdAt;

  ConversationSummaryModel({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory ConversationSummaryModel.fromJson(Map<String, dynamic> json) => _$ConversationSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationSummaryModelToJson(this);
}
