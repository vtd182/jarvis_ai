import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../config/config.dart';

part 'ai_chat_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/ai-chat")
abstract class AIChatService {
  @factoryMethod
  factory AIChatService(Dio dio) = _AIChatService;

  @POST("")
  Future<dynamic> doAIChat(@Body() Map<String, dynamic> body);

  @GET("/conversations")
  Future<dynamic> getConversations(
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("assistantId") String assistantId,
    @Query("assistantModel") String assistantModel,
  );

  @GET("conversations/{conversationId}/messages")
  Future<dynamic> getMessages(
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("assistantId") String assistantId,
    @Query("assistantModel") String assistantModel,
  );

  @POST("/messages")
  Future<dynamic> sendMessage(@Body() Map<String, dynamic> body);
}
