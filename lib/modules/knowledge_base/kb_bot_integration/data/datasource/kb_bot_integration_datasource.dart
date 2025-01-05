import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_bot_integration/data/datasource/services/kb_bot_integration_service.dart';

abstract class KBBotIntegrationDataSource {
  // /kb-core/v1/bot-integration/{assistantId}/configurations
  Future<String> getConfigurations({required String assistantId});

  // /kb-core/v1/bot-integration/{assistantId}/{type}
  Future<String> deleteIntegration({
    required String assistantId,
    required String type,
  });

  // /kb-core/v1/bot-integration/telegram/validation
  // {
  // "botToken": "string",
  // }
  Future<String> validateTelegramIntegration({
    required String botToken,
  });

  // /kb-core/v1/bot-integration/telegram/publish/{assistantId}
  Future<String> publishTelegramIntegration({
    required String assistantId,
    required String botToken,
  });

  // /kb-core/v1/bot-integration/slack/validation
  // {
  // "botToken": "string",
  // "clientId": "string",
  // "clientSecret": "string",
  // "signingSecret": "string"
  // }
  Future<String> validateSlackIntegration({
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  });

  // /kb-core/v1/bot-integration/slack/publish/{assistantId}
  Future<String> publishSlackIntegration({
    required String assistantId,
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  });

  // /kb-core/v1/bot-integration/messenger/validation
  // {
  // "botToken": "string",
  // "pageId": "string",
  // "appSecret": "string"
  // }
  Future<String> validateMessengerIntegration({
    required String botToken,
    required String pageId,
    required String appSecret,
  });

  // /kb-core/v1/bot-integration/messenger/publish/{assistantId}
  Future<String> publishMessengerIntegration({
    required String assistantId,
    required String botToken,
    required String pageId,
    required String appSecret,
  });
}

@LazySingleton(as: KBBotIntegrationDataSource)
class KBBotIntegrationDataSourceImp implements KBBotIntegrationDataSource {
  final KBBotIntegrationService _service;
  KBBotIntegrationDataSourceImp(this._service);

  @override
  Future<String> deleteIntegration({required String assistantId, required String type}) {
    return _service.deleteIntegration(assistantId, type);
  }

  @override
  Future<String> getConfigurations({required String assistantId}) {
    return _service.getConfigurations(assistantId);
  }

  @override
  Future<String> publishMessengerIntegration(
      {required String assistantId, required String botToken, required String pageId, required String appSecret}) {
    return _service.publishMessengerIntegration(
      assistantId,
      {
        "botToken": botToken,
        "pageId": pageId,
        "appSecret": appSecret,
      },
    );
  }

  @override
  Future<String> publishSlackIntegration(
      {required String assistantId,
      required String botToken,
      required String clientId,
      required String clientSecret,
      required String signingSecret}) {
    return _service.publishSlackIntegration(
      assistantId,
      {
        "botToken": botToken,
        "clientId": clientId,
        "clientSecret": clientSecret,
        "signingSecret": signingSecret,
      },
    );
  }

  @override
  Future<String> publishTelegramIntegration({required String assistantId, required String botToken}) {
    return _service.publishTelegramIntegration(
      assistantId,
      {
        "botToken": botToken,
      },
    );
  }

  @override
  Future<String> validateMessengerIntegration({required String botToken, required String pageId, required String appSecret}) {
    return _service.validateMessengerIntegration(
      {
        "botToken": botToken,
        "pageId": pageId,
        "appSecret": appSecret,
      },
    );
  }

  @override
  Future<String> validateSlackIntegration(
      {required String botToken, required String clientId, required String clientSecret, required String signingSecret}) {
    return _service.validateSlackIntegration(
      {
        "botToken": botToken,
        "clientId": clientId,
        "clientSecret": clientSecret,
        "signingSecret": signingSecret,
      },
    );
  }

  @override
  Future<String> validateTelegramIntegration({required String botToken}) {
    return _service.validateTelegramIntegration(
      {
        "botToken": botToken,
      },
    );
  }
}
