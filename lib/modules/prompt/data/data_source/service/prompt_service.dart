import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:retrofit/retrofit.dart';

part 'prompt_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/prompts")
abstract class PromptService {
  @factoryMethod
  factory PromptService(Dio dio) = _PromptService;

  @GET("")
  Future<dynamic> getPrompts(@Queries() Map<String, dynamic> queries);

  @POST("")
  Future<dynamic> createPrompt(@Body() Map<String, dynamic> body);

  @PATCH("/{id}")
  Future<dynamic> updatePrompt(@Path("id") String id, @Body() Map<String, dynamic> body);

  @DELETE("/{id}")
  Future<dynamic> deletePrompt(@Path("id") String id);

  @POST("/{id}/favorite")
  Future<dynamic> addPromptFavorite(@Path("id") String id);

  @DELETE("/{id}/favorite")
  Future<dynamic> removePromptFavorite(@Path("id") String id);

}