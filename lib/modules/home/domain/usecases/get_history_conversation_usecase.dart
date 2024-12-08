import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/repositories/ai_chat_repository.dart';
import 'package:jarvis_ai/modules/home/domain/models/get_conversations_response.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetHistoryConversationUseCase extends Usecase {
  final AIChatRepository _aiChatRepository;

  const GetHistoryConversationUseCase(this._aiChatRepository);

  Future<GetConversationsResponse> run({
    required String? cursor,
    required int? limit,
    required String? assistantId,
    required String assistantModel,
  }) {
    return _aiChatRepository.getConversations(cursor, limit, assistantId, assistantModel);
  }
}
