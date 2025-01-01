import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/repositories/kb_bot_integration_repositoy.dart';

@lazySingleton
class ValidateMessengerIntegrationUseCase {
  final KBBotIntegrationRepository _repository;

  ValidateMessengerIntegrationUseCase(this._repository);

  Future<Response> run({
    required String botToken,
    required String pageId,
    required String appSecret,
  }) {
    return _repository.validateMessengerIntegration(
      botToken: botToken,
      pageId: pageId,
      appSecret: appSecret,
    );
  }
}
