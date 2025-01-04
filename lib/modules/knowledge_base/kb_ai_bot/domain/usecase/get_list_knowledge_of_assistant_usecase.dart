import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_knowledge.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_response_with_pagination.dart';

@lazySingleton
class GetListKnowledgeOfAssistantUseCase {
  final KBAIAssistantRepository _aiAssistantRepository;

  GetListKnowledgeOfAssistantUseCase(this._aiAssistantRepository);

  Future<KBResponseWithPagination<KBAIKnowledge>> run({
    required String assistantId,
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
  }) {
    return _aiAssistantRepository.getListKnowledgeOfKBAIAssistant(
      assistantId: assistantId,
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
    );
  }
}
