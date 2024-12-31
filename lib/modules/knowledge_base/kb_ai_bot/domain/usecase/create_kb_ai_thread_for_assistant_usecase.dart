import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_thread.dart';

@lazySingleton
class CreateKBAIThreadForAssistantUseCase {
  final KBAIAssistantRepository _repository;

  CreateKBAIThreadForAssistantUseCase(this._repository);

  Future<KBAIThread> run({
    required String assistantId,
    required String firstMessage,
  }) {
    return _repository.createKBAIThreadForAssistant(
      assistantId: assistantId,
      firstMessage: firstMessage,
    );
  }
}
