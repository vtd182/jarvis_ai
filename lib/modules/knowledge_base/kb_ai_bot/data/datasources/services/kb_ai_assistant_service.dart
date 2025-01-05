import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_knowledge.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_message.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_thread.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_response_with_pagination.dart';
import 'package:retrofit/retrofit.dart';

part 'kb_ai_assistant_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.knowledgeBaseUrl}/kb-core/v${Config.apiVersion}/ai-assistant")
abstract class KBAIAssistantService {
  @factoryMethod
  factory KBAIAssistantService(Dio dio) = _KBAIAssistantService;

  @POST("")
  Future<KBAIAssistant> createKBAIAssistant(@Body() Map<String, dynamic> body);

  @PATCH("/{assistantId}")
  Future<KBAIAssistant> updateKBAIAssistant(@Path("assistantId") String assistantId, @Body() Map<String, dynamic> body);

  @GET("/{assistantId}")
  Future<KBAIAssistant> getKBAIAssistant(@Path("assistantId") String assistantId);

  @DELETE("/{assistantId}")
  Future<String> deleteKBAIAssistant(@Path("assistantId") String assistantId);

  @GET("")
  Future<KBResponseWithPagination<KBAIAssistant>> getListKBAIAssistant(
    @Query("q") String query,
    @Query("order") String order,
    @Query("order_field") String orderField,
    @Query("offset") int offset,
    @Query("limit") int limit,
    @Query("is_favorite") bool? isFavorite,
    @Query("is_published") bool? isPublished,
  );

  @POST("/{assistantId}/knowledges/{knowledgeId}")
  Future<String> importKnowledgeToKBAIAssistant(
    @Path("assistantId") String assistantId,
    @Path("knowledgeId") String knowledgeId,
  );

  @DELETE("/{assistantId}/knowledges/{knowledgeId}")
  Future<String> removeKnowledgeFromKBAIAssistant(
    @Path("assistantId") String assistantId,
    @Path("knowledgeId") String knowledgeId,
  );

  @GET("/{assistantId}/knowledges")
  Future<KBResponseWithPagination<KBAIKnowledge>> getListKnowledgeOfKBAIAssistant(
    @Path("assistantId") String assistantId,
    @Query("q") String query,
    @Query("order") String order,
    @Query("order_field") String orderField,
    @Query("offset") int offset,
    @Query("limit") int limit,
  );

  @POST("/thread")
  Future<KBAIThread> createKBAIThreadForAssistant(@Body() Map<String, dynamic> body);

  @POST("/thread/playground")
  Future<KBAIThread> updateAssistantWithNewThreadPlayground(@Body() Map<String, dynamic> body);

  @POST("/{assistantId}/ask")
  Future<String> askToKBAIAssistant(
    @Path("assistantId") String assistantId,
    @Body() Map<String, dynamic> body,
  );

  @GET("/thread/{openAiThreadId}/messages")
  Future<List<KBAIMessage>> getMessagesOfKBAIThread(
    @Path("openAiThreadId") String openAiThreadId,
    @Query("q") String query,
    @Query("order") String order,
    @Query("order_field") String orderField,
    @Query("offset") int offset,
    @Query("limit") int limit,
  );

  @GET("/{assistantId}/threads")
  Future<KBResponseWithPagination<KBAIThread>> getListKBAIThreadOfAssistant(
    @Path("assistantId") String assistantId,
    @Query("q") String query,
    @Query("order") String order,
    @Query("order_field") String orderField,
    @Query("offset") int offset,
    @Query("limit") int limit,
  );

  @POST("/{assistantId}/favorite")
  Future<KBAIAssistant> favoriteKBAIAssistant(@Path("assistantId") String assistantId);
}
