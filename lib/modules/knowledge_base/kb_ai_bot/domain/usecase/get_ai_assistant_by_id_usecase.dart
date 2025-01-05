import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';

@lazySingleton
class GetAIAssistantByIdUseCase {
  final KBAIAssistantRepository _aiAssistantRepository;

  GetAIAssistantByIdUseCase(this._aiAssistantRepository);

  Future<KBAIAssistant> run({required String assistantId}) {
    return _aiAssistantRepository.getKBAIAssistant(assistantId: assistantId);
  }
}
