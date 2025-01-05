import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kb_page_meta.dart';

part 'kb_response_with_pagination.g.dart';

@JsonSerializable(genericArgumentFactories: true)
@CopyWith()
class KBResponseWithPagination<T> extends Equatable {
  @JsonKey(name: 'data')
  final List<T> data;

  @JsonKey(name: 'meta')
  final KBPageMeta meta;

  const KBResponseWithPagination({
    required this.data,
    required this.meta,
  });

  factory KBResponseWithPagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$KBResponseWithPaginationFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$KBResponseWithPaginationToJson(this, toJsonT);

  @override
  List<Object?> get props => [data, meta];
}
