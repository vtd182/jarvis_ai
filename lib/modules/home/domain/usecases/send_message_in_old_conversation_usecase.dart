import 'package:suga_core/suga_core.dart';

import '../../data/repositories/ai_chat_repository.dart';
import '../models/ai_chat_response.dart';
import '../models/assistant_model.dart';
import '../models/message_model.dart';

class SendMessageInOldConversationUseCase extends Usecase {
  final AIChatRepository _aiChatRepository;

  const SendMessageInOldConversationUseCase(this._aiChatRepository);

  Future<AIChatResponse> run({
    required String content,
    required String conversationId,
    required List<MessageModel> messages,
    required AssistantModel assistant,
  }) async {
    final response = await _aiChatRepository.sendMessage(content, conversationId, messages, assistant);
    return response;
  }
}
