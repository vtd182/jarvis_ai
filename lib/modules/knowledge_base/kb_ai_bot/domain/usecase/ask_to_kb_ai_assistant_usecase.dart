import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';

@lazySingleton
class AskToKBAiAssistantUseCase {
  final KBAIAssistantRepository _repository;

  AskToKBAiAssistantUseCase(this._repository);

  Future<String> run({
    required String assistantId,
    required String message,
    required String openAiThreadId,
    required String additionalInstruction,
  }) {
    return _repository.askToKBAIAssistant(
      assistantId: assistantId,
      message: message,
      openAiThreadId: openAiThreadId,
      additionalInstruction: additionalInstruction,
    );
  }
}
