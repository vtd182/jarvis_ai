import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:retrofit/retrofit.dart';

part 'knowledge_base_auth_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.knowledgeBaseUrl}/kb-core/v${Config.apiVersion}/auth")
abstract class KnowledgeBaseAuthService {
  @factoryMethod
  factory KnowledgeBaseAuthService(Dio dio) = _KnowledgeBaseAuthService;

  @POST("/external-sign-in")
  Future<dynamic> signInFromExternalClient(
    @Body() Map<String, dynamic> body,
  );

  @GET("/refresh")
  Future<dynamic> refreshToken(@Query("refreshToken") String refreshToken);
}
