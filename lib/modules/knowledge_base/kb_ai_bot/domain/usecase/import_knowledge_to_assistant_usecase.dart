import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';

@lazySingleton
class ImportKnowledgeToAssistantUseCase {
  final KBAIAssistantRepository _aiAssistantRepository;

  ImportKnowledgeToAssistantUseCase(this._aiAssistantRepository);

  Future<String> run({
    required String assistantId,
    required String knowledgeId,
  }) {
    return _aiAssistantRepository.importKnowledgeToKBAIAssistant(
      assistantId: assistantId,
      knowledgeId: knowledgeId,
    );
  }
}
