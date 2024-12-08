import 'package:jarvis_ai/modules/prompt/domain/model/prompt_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prompts_response_model.g.dart';

@JsonSerializable()
class PromptsResponseModel {
  PromptsResponseModel({
    this.hasNext,
    this.offset,
    this.limit,
    this.total,
    this.items,
  });
  final bool? hasNext;
  final int? offset;
  final int? limit;
  final int? total;
  final List<PromptItemModel>? items;

  factory PromptsResponseModel.fromJson(Map<String, dynamic> json) => _$PromptsResponseModelFromJson(json);
}
