import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';

@lazySingleton
class RemoveKnowledgeFromAssistantUseCase {
  final KBAIAssistantRepository _aiAssistantRepository;

  RemoveKnowledgeFromAssistantUseCase(this._aiAssistantRepository);

  Future<String> run({
    required String assistantId,
    required String knowledgeId,
  }) {
    return _aiAssistantRepository.removeKnowledgeFromKBAIAssistant(
      assistantId: assistantId,
      knowledgeId: knowledgeId,
    );
  }
}
