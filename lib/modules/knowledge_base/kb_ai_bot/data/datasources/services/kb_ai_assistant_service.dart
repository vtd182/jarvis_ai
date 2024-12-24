import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
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
  Future<bool> deleteKBAIAssistant(@Path("assistantId") String assistantId);

  @GET("")
  Future<List<KBAIAssistant>> getListKBAIAssistant(
    @Query("q") String query,
    @Query("order") String order,
    @Query("order_field") String orderField,
    @Query("offset") int offset,
    @Query("limit") int limit,
    @Query("is_favorite") bool isFavorite,
    @Query("is_published") bool isPublished,
  );
}
