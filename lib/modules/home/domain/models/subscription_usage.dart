import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_usage.g.dart';

@JsonSerializable()
@CopyWith()
class SubscriptionUsage extends Equatable {
  @JsonKey(name: "name")
   String name;

  @JsonKey(name: "dailyTokens")
  int daily;

  @JsonKey(name: "monthlyTokens")
    int monthly;

  @JsonKey(name: "annuallyTokens")
    int annually;

  SubscriptionUsage({
        required this.name,
        required this.daily,
        required this.monthly,
        required this.annually,
  });

  @override
  List<Object?> get props => [name, daily, monthly, annually];

  factory SubscriptionUsage.fromJson(Map<String, dynamic> json) => _$SubscriptionUsageFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionUsageToJson(this);
}
