import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_usage.g.dart';

// {
// "availableTokens": 50,
// "totalTokens": 50,
// "unlimited": false,
// "date": "2024-11-09T02:24:40.588Z"
// }
@JsonSerializable()
@CopyWith()
class TokenUsage extends Equatable {
  @JsonKey(name: "availableTokens")
  int availableTokens;

  @JsonKey(name: "totalTokens")
  int totalTokens;

  @JsonKey(name: "unlimited")
  bool unlimited;

  @JsonKey(name: "date")
  DateTime date;

  TokenUsage({
    required this.availableTokens,
    required this.totalTokens,
    required this.unlimited,
    required this.date,
  });

  @override
  List<Object?> get props => [availableTokens, totalTokens, unlimited, date];

  factory TokenUsage.fromJson(Map<String, dynamic> json) => _$TokenUsageFromJson(json);
  Map<String, dynamic> toJson() => _$TokenUsageToJson(this);
}
