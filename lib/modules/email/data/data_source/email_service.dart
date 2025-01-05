import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:jarvis_ai/modules/email/domain/model/email_idea_suggestion_response.dart';

import 'package:jarvis_ai/modules/email/domain/model/email_reply_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'email_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/ai-email")
abstract class EmailService {
  @factoryMethod
  factory EmailService(Dio dio) = _EmailService;

  @POST("")
  Future<EmailReplyResponse> responseEmail(@Body() Map<String, dynamic> body);

  @POST("/reply-ideas")
  Future<EmailIdeaSuggestionResponse> suggestReplyIdeas(@Body() Map<String, dynamic> body);
}
