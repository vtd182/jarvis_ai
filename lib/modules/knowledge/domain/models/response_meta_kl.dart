import 'package:json_annotation/json_annotation.dart';

part 'response_meta_kl.g.dart';

@JsonSerializable()
class ResponseMetaKl {
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;

  ResponseMetaKl({
    required this.limit,
    required this.offset,
    required this.total,
    required this.hasNext,
  });

  factory ResponseMetaKl.fromJson(Map<String, dynamic> json) => _$ResponseMetaKlFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseMetaKlToJson(this);
}
