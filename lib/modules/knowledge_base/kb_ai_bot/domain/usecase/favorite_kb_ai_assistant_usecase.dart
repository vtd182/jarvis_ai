import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';

@lazySingleton
class FavoriteKBAIAssistantUseCase {
  final KBAIAssistantRepository _repository;

  FavoriteKBAIAssistantUseCase(this._repository);

  Future<KBAIAssistant> run({
    required String assistantId,
  }) {
    return _repository.favoriteKBAIAssistant(
      assistantId: assistantId,
    );
  }
}
