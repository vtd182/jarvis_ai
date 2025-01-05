import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';

@lazySingleton
class CreateAIAssistantUseCase {
  final KBAIAssistantRepository _repository;

  CreateAIAssistantUseCase(this._repository);

  Future<KBAIAssistant> run({
    required String assistantName,
    required String instructions,
    required String description,
  }) {
    return _repository.createKBAIAssistant(
      assistantName: assistantName,
      instructions: instructions,
      description: description,
    );
  }
}
