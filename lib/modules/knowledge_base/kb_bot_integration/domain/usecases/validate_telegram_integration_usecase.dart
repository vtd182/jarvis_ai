import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class ValidateTelegramIntegrationUseCase {
  final KBBotIntegrationRepository _repository;

  ValidateTelegramIntegrationUseCase(this._repository);

  Future<String> run({
    required String botToken,
  }) {
    return _repository.validateTelegramIntegration(
      botToken: botToken,
    );
  }
}
