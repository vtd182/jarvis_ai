import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class PublishSlackIntegrationUseCase {
  final KBBotIntegrationRepository _repository;

  PublishSlackIntegrationUseCase(this._repository);

  Future<Response> run({
    required String assistantId,
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  }) {
    return _repository.publishSlackIntegration(
      assistantId: assistantId,
      botToken: botToken,
      clientId: clientId,
      clientSecret: clientSecret,
      signingSecret: signingSecret,
    );
  }
}
