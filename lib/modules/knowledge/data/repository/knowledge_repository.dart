import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/data_source/service/knowledge_service.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';

@lazySingleton
class KnowledgeRepository {
  final KnowledgeService _knowledgeService;

  KnowledgeRepository(this._knowledgeService);

  Future<dynamic> getKnowledge({required RequestKnowledgeModel queries}) async {
    return _knowledgeService.getKnowledge(queries);
  }
}