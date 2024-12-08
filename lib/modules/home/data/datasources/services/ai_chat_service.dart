import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/domain/models/ai_chat_response.dart';
import 'package:jarvis_ai/modules/home/domain/models/get_conversation_history_response.dart';
import 'package:jarvis_ai/modules/home/domain/models/get_conversations_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../config/config.dart';

part 'ai_chat_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/ai-chat")
abstract class AIChatService {
  @factoryMethod
  factory AIChatService(Dio dio) = _AIChatService;

  // Chat moi
  @POST("")
  Future<AIChatResponse> doAIChat(@Body() Map<String, dynamic> body);

  // Lay ra cac title trong lich su chat
  @GET("/conversations")
  Future<GetConversationsResponse> getConversations(
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("assistantId") String? assistantId,
    @Query("assistantModel") String assistantModel,
  );

  // Lay ra cac tin nhan cu trong hoi thoai
  @GET("/conversations/{conversationId}/messages")
  Future<GetConversationsHistoryResponse> getMessages(
    @Path("conversationId") String conversationId,
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("assistantId") String assistantId,
    @Query("assistantModel") String assistantModel,
  );

  // chat tren lich su cu
  @POST("/messages")
  Future<AIChatResponse> sendMessage(@Body() Map<String, dynamic> body);
}
