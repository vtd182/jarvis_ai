import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/datasources/ai_chat_datasource.dart';

import '../../domain/enums/assistant.dart';
import '../../domain/models/ai_chat_response.dart';
import '../../domain/models/assistant_model.dart';
import '../../domain/models/get_conversation_history_response.dart';
import '../../domain/models/get_conversations_response.dart';
import '../../domain/models/message_model.dart';

@lazySingleton
class AIChatRepository {
  final AIChatDatasource _aiChatDatasource;
  const AIChatRepository(this._aiChatDatasource);

  // Chat moi
  Future<AIChatResponse> doAIChat(
    Assistant assistant,
    String message,
  ) {
    return _aiChatDatasource.doAIChat(assistant, message);
  }

  // Lay ra cac title trong lich su chat
  Future<GetConversationsResponse> getConversations(
    String? cursor,
    int? limit,
    String? assistantId,
    String assistantModel,
  ) {
    return _aiChatDatasource.getConversations(cursor, limit, assistantId, assistantModel);
  }

  // Lay ra cac tin nhan cu trong hoi thoai
  Future<GetConversationsHistoryResponse> getMessages(
    String? cursor,
    int? limit,
    String assistantId,
    String assistantModel,
  ) {
    return _aiChatDatasource.getMessages(cursor, limit, assistantId, assistantModel);
  }

  // chat tren lich su cu
  Future<AIChatResponse> sendMessage(
    String content,
    String conversationId,
    List<MessageModel> messages,
    AssistantModel assistant,
  ) {
    return _aiChatDatasource.sendMessage(content, conversationId, messages, assistant);
  }
}
