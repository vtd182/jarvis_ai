import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class PublishTelegramIntegrationUseCase {
  final KBBotIntegrationRepository _repository;

  PublishTelegramIntegrationUseCase(this._repository);

  Future<Response> run({
    required String assistantId,
    required String botToken,
  }) {
    return _repository.publishTelegramIntegration(
      assistantId: assistantId,
      botToken: botToken,
    );
  }
}
