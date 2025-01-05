import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class PublishMessengerIntegrationUseCase {
  final KBBotIntegrationRepository _repository;

  PublishMessengerIntegrationUseCase(this._repository);

  Future<String> run({
    required String assistantId,
    required String botToken,
    required String pageId,
    required String appSecret,
  }) {
    return _repository.publishMessengerIntegration(
      assistantId: assistantId,
      botToken: botToken,
      pageId: pageId,
      appSecret: appSecret,
    );
  }
}
