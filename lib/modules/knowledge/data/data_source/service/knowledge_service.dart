import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:retrofit/retrofit.dart';

part 'knowledge_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.knowledgeBaseUrl}/kb-core/v${Config.apiVersion}/knowledge")
abstract class KnowledgeService {
  @factoryMethod
  factory KnowledgeService(Dio dio) = _KnowledgeService;

  @GET("")
  Future<dynamic> getKnowledge(@Queries() RequestKnowledgeModel queries);
}
