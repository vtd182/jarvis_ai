import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/datasource/kb_bot_integration_datasource.dart';

class KBBotIntegrationRepository {
  final KBBotIntegrationDataSource _dataSource;
  KBBotIntegrationRepository(this._dataSource);

  @override
  Future<String> deleteIntegration({required String assistantId, required String type}) {
    return _dataSource.deleteIntegration(assistantId: assistantId, type: type);
  }

  @override
  Future<String> getConfigurations({required String assistantId}) {
    return _dataSource.getConfigurations(assistantId: assistantId);
  }

  @override
  Future<String> publishMessengerIntegration({
    required String assistantId,
    required String botToken,
    required String pageId,
    required String appSecret,
  }) {
    return _dataSource.publishMessengerIntegration(
      assistantId: assistantId,
      botToken: botToken,
      pageId: pageId,
      appSecret: appSecret,
    );
  }

  @override
  Future<String> publishSlackIntegration({
    required String assistantId,
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  }) {
    return _dataSource.publishSlackIntegration(
      assistantId: assistantId,
      botToken: botToken,
      clientId: clientId,
      clientSecret: clientSecret,
      signingSecret: signingSecret,
    );
  }

  @override
  Future<String> publishTelegramIntegration({
    required String assistantId,
    required String botToken,
  }) {
    return _dataSource.publishTelegramIntegration(
      assistantId: assistantId,
      botToken: botToken,
    );
  }

  @override
  Future<String> validateMessengerIntegration({required String botToken, required String pageId, required String appSecret}) {
    return _dataSource.validateMessengerIntegration(
      botToken: botToken,
      pageId: pageId,
      appSecret: appSecret,
    );
  }

  @override
  Future<String> validateSlackIntegration(
      {required String botToken, required String clientId, required String clientSecret, required String signingSecret}) {
    return _dataSource.validateSlackIntegration(
      botToken: botToken,
      clientId: clientId,
      clientSecret: clientSecret,
      signingSecret: signingSecret,
    );
  }

  @override
  Future<String> validateTelegramIntegration({required String botToken}) {
    return _dataSource.validateTelegramIntegration(botToken: botToken);
  }
}
