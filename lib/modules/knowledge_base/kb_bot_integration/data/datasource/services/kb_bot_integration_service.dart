import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:retrofit/retrofit.dart';

part 'kb_bot_integration_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.knowledgeBaseUrl}/kb-core/v${Config.apiVersion}/bot-integration")
abstract class KBBotIntegrationService {
  @factoryMethod
  factory KBBotIntegrationService(Dio dio) = _KBBotIntegrationService;

  // /kb-core/v1/bot-integration/{assistantId}/configurations
  @GET("/{assistantId}/configurations")
  Future<String> getConfigurations(@Path("assistantId") String assistantId);

  // /kb-core/v1/bot-integration/{assistantId}/{type}
  @DELETE("/{assistantId}/{type}")
  Future<String> deleteIntegration(
    @Path("assistantId") String assistantId,
    @Path("type") String type,
  );

  // /kb-core/v1/bot-integration/telegram/validation
  @POST("/telegram/validation")
  Future<String> validateTelegramIntegration(Map<String, dynamic> body);

  // /kb-core/v1/bot-integration/telegram/publish/{assistantId}
  @POST("/telegram/publish/{assistantId}")
  Future<String> publishTelegramIntegration(
    @Path("assistantId") String assistantId,
    @Body() Map<String, dynamic> body,
  );

  // /kb-core/v1/bot-integration/slack/validation
  @POST("/slack/validation")
  Future<String> validateSlackIntegration(Map<String, dynamic> body);

  // /kb-core/v1/bot-integration/slack/publish/{assistantId}
  @POST("/slack/publish/{assistantId}")
  Future<String> publishSlackIntegration(
    @Path("assistantId") String assistantId,
    @Body() Map<String, dynamic> body,
  );

  // /kb-core/v1/bot-integration/messenger/validation
  @POST("/messenger/validation")
  Future<String> validateMessengerIntegration(Map<String, dynamic> body);

  // /kb-core/v1/bot-integration/messenger/publish/{assistantId}
  @POST("/messenger/publish/{assistantId}")
  Future<String> publishMessengerIntegration(
    @Path("assistantId") String assistantId,
    @Body() Map<String, dynamic> body,
  );
}
