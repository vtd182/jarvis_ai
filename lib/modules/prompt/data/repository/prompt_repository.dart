import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/prompt/data/data_source/service/prompt_service.dart';

@lazySingleton
class PromptRepository {
  final PromptService _promptService;

  PromptRepository(this._promptService);

  Future<dynamic> getPrompt({required Map<String, dynamic> queries}) async {
    return _promptService.getPrompts(queries);
  }

  Future<dynamic> createPrompt(
      {required String category,
      required String content,
      required String description,
      required bool isPublic,
      required String language,
      required String title}) async {
    return _promptService.createPrompt({
      "category": category,
      "content": content,
      "description": description,
      "isPublic": isPublic,
      "language": language,
      "title": title,
    });
  }

  Future<dynamic> updatePrompt(
      {required String id,
      required String category,
      String? content,
      required String description,
      required bool isPublic,
      required String language,
      String? title}) async {
    final queries = {
      "category": category,
      "description": description,
      "isPublic": isPublic,
      "language": language,
    };
    if (content != null) {
      queries["content"] = content;
    }
    if (title != null) {
      queries["title"] = title;
    }
    return _promptService.updatePrompt(id, queries);
  }

  Future<dynamic> deletePrompt({required String id}) async {
    return _promptService.deletePrompt(id);
  }

  Future<dynamic> addFavoritePrompt({required String id}) async {
    return _promptService.addPromptFavorite(id);
  }

  Future<dynamic> removeFavoritePrompt({required String id}) async {
    return _promptService.removePromptFavorite(id);
  }
}
