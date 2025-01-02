import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class DeleteIntegrationUseCase {
  final KBBotIntegrationRepository _repository;

  DeleteIntegrationUseCase(this._repository);

  Future<String> run({required String assistantId, required String type}) {
    return _repository.deleteIntegration(assistantId: assistantId, type: type);
  }
}
