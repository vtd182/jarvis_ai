import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_meta_kl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_get_list_unit.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseGetListUnit {
  final List<ResponseGetUnit> data;
  final ResponseMetaKl meta;

  ResponseGetListUnit({
    required this.data,
    required this.meta,
  });

  factory ResponseGetListUnit.fromJson(Map<String, dynamic> json) => _$ResponseGetListUnitFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseGetListUnitToJson(this);
}
