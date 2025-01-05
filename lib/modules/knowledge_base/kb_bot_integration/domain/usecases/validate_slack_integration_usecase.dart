import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class ValidateSlackIntegrationUseCase {
  final KBBotIntegrationRepository _repository;

  ValidateSlackIntegrationUseCase(this._repository);

  Future<String> run({
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  }) {
    return _repository.validateSlackIntegration(
      botToken: botToken,
      clientId: clientId,
      clientSecret: clientSecret,
      signingSecret: signingSecret,
    );
  }
}
