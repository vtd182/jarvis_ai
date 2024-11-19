// "assistant": {
// "id": "claude-3-haiku-20240307",
// "model": "dify",
// "name": "Claude 3 Haiku"
// }

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:jarvis_ai/modules/home/domain/enums/assistant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assistant_model.g.dart';

@JsonSerializable()
@CopyWith()
class AssistantModel {
  @JsonKey(name: "id")
  final Assistant id;
  @JsonKey(name: "model")
  final String model;
  @JsonKey(name: "name")
  final String name;

  AssistantModel({required this.id, required this.model, required this.name});

  factory AssistantModel.fromJson(Map<String, dynamic> json) => _$AssistantModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssistantModelToJson(this);
}
