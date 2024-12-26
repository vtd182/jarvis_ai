import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';

@lazySingleton
class DeleteAIAssistantByIdUseCase {
  final KBAIAssistantRepository _repository;

  DeleteAIAssistantByIdUseCase(this._repository);

  Future<void> run({required String assistantId}) {
    return _repository.deleteKBAIAssistant(assistantId: assistantId);
  }
}
