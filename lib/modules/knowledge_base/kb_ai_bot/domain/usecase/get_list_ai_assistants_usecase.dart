import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_response_with_pagination.dart';

@lazySingleton
class GetListAIAssistantsUseCase {
  final KBAIAssistantRepository _aiAssistantRepository;

  GetListAIAssistantsUseCase(this._aiAssistantRepository);

  Future<KBResponseWithPagination<KBAIAssistant>> run({
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
    required bool isFavorite,
    required bool isPublished,
  }) {
    return _aiAssistantRepository.getListKBAIAssistant(
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
      isFavorite: isFavorite,
      isPublished: isPublished,
    );
  }
}
