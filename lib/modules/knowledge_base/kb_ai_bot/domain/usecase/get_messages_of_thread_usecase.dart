import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/repositories/kb_ai_assistant_repository.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_message.dart';

@lazySingleton
class GetMessagesOfThreadUseCase {
  final KBAIAssistantRepository _aiAssistantRepository;

  GetMessagesOfThreadUseCase(this._aiAssistantRepository);

  Future<List<KBAIMessage>> run({
    required String openAiThreadId,
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
  }) {
    return _aiAssistantRepository.getMessagesOfKBAIThread(
      openAiThreadId: openAiThreadId,
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
    );
  }
}
