import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kb_page_meta.g.dart';

@JsonSerializable()
@CopyWith()
class KBPageMeta extends Equatable {
  @JsonKey(name: 'limit')
  int limit;
  @JsonKey(name: 'total')
  int total;
  @JsonKey(name: 'offset')
  int offset;
  @JsonKey(name: 'hasNext')
  bool hasNext;

  KBPageMeta({
    required this.limit,
    required this.total,
    required this.offset,
    required this.hasNext,
  });

  factory KBPageMeta.fromJson(Map<String, dynamic> json) => _$KBPageMetaFromJson(json);
  Map<String, dynamic> toJson() => _$KBPageMetaToJson(this);
  @override
  List<Object?> get props => [limit, total, offset, hasNext];
}
