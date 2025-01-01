import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_meta_kl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_get_list_kl.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseGetListKl {
  final List<ResponseGetKl> data;
  final ResponseMetaKl meta;

  ResponseGetListKl({
    required this.data,
    required this.meta,
  });

  factory ResponseGetListKl.fromJson(Map<String, dynamic> json) =>
      _$ResponseGetListKlFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseGetListKlToJson(this);
}
