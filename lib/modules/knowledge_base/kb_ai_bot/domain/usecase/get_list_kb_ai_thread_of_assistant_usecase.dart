import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_thread.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_response_with_pagination.dart';

@lazySingleton
class GetListKBAIThreadOfAssistantUseCase {
  final KBAIAssistantRepository _aiAssistantRepository;

  GetListKBAIThreadOfAssistantUseCase(this._aiAssistantRepository);

  Future<KBResponseWithPagination<KBAIThread>> run({
    required String assistantId,
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
  }) {
    return _aiAssistantRepository.getListKBAIThreadOfAssistant(
      assistantId: assistantId,
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
    );
  }
}
