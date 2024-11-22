import 'package:injectable/injectable.dart';
import 'package:suga_core/suga_core.dart';

import '../../data/repositories/ai_chat_repository.dart';
import '../models/get_conversation_history_response.dart';

@lazySingleton
class GetMessageInConversationUseCase extends Usecase {
  final AIChatRepository _aiChatRepository;
  const GetMessageInConversationUseCase(this._aiChatRepository);
  Future<GetConversationsHistoryResponse> run({
    required String conversationId,
    required String? cursor,
    required int? limit,
    required String assistantId,
    required String assistantModel,
  }) async {
    final messages = await _aiChatRepository.getMessages(conversationId, cursor, limit, assistantId, assistantModel);
    return messages;
  }
}
