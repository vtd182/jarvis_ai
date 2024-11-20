import 'package:json_annotation/json_annotation.dart';

part 'prompt_item_model.g.dart';

@JsonSerializable()
class PromptItemModel {
  PromptItemModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.content,
    this.description,
    this.isPublic,
    this.language,
    this.title,
    this.userId,
    this.userName,
    this.isFavorite,
  });

  @JsonKey(name: '_id')
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? category;
  final String? content;
  final String? description;
  final bool? isPublic;
  final String? language;
  final String? title;
  final String? userId;
  final String? userName;
  final bool? isFavorite;

  factory PromptItemModel.fromJson(Map<String, dynamic> json) =>
      _$PromptItemModelFromJson(json);

  PromptItemModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    String? content,
    String? description,
    bool? isPublic,
    String? language,
    String? title,
    String? userId,
    String? userName,
    bool? isFavorite,
  }) {
    return PromptItemModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      content: content ?? this.content,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      language: language ?? this.language,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
