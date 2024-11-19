import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
@CopyWith()
class UserModel {
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'roles')
  List<String> roles;
  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.roles,
  });
  List<Object?> get props => [id];
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
