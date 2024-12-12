
import 'package:json_annotation/json_annotation.dart';

part 'request_knowledge_model.g.dart';

@JsonSerializable()
class RequestKnowledgeModel {
  String? q;

  String? order;

  @JsonKey(name: "order_field")
  String? orderField;

  int? offset;

  int? limit;

  RequestKnowledgeModel({this.q, this.order = "DESC", this.orderField, this.offset, this.limit = 10});

  factory RequestKnowledgeModel.fromJson(Map<String, dynamic> json) => _$RequestKnowledgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestKnowledgeModelToJson(this);

}