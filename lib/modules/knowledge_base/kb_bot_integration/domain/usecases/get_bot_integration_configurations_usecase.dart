import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class GetBotIntegrationConfigurationsUseCase {
  final KBBotIntegrationRepository _repository;

  GetBotIntegrationConfigurationsUseCase(this._repository);

  Future<String> run({required String assistantId}) {
    return _repository.getConfigurations(assistantId: assistantId);
  }
}
