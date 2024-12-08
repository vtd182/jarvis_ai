import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/datasources/services/ai_chat_service.dart';
import 'package:jarvis_ai/modules/home/domain/enums/assistant.dart';
import 'package:jarvis_ai/modules/home/domain/models/assistant_model.dart';

import '../../domain/models/ai_chat_response.dart';
import '../../domain/models/get_conversation_history_response.dart';
import '../../domain/models/get_conversations_response.dart';
import '../../domain/models/message_model.dart';

abstract class AIChatDatasource {
  // Chat moi
  Future<AIChatResponse> doAIChat(
    Assistant assistant,
    String message,
  );

  // Lay ra cac title trong lich su chat
  Future<GetConversationsResponse> getConversations(
    String? cursor,
    int? limit,
    String? assistantId,
    String assistantModel,
  );

  // Lay ra cac tin nhan cu trong hoi thoai
  Future<GetConversationsHistoryResponse> getMessages(
    String conversationId,
    String? cursor,
    int? limit,
    String assistantId,
    String assistantModel,
  );

  // chat tren lich su cu
  Future<AIChatResponse> sendMessage(
    String content,
    String conversationId,
    List<MessageModel> messages,
    AssistantModel assistant,
  );
}

@LazySingleton(as: AIChatDatasource)
class AIChatDatasourceImpl implements AIChatDatasource {
  final AIChatService _aiChatService;

  AIChatDatasourceImpl(this._aiChatService);
  @override
  Future<AIChatResponse> doAIChat(Assistant assistant, String message) {
    return _aiChatService.doAIChat({
      "assistant": {
        "id": assistant.value,
        "model": "dify",
      },
      "content": message
    });
  }

  @override
  Future<GetConversationsResponse> getConversations(
    String? cursor,
    int? limit,
    String? assistantId,
    String assistantModel,
  ) {
    return _aiChatService.getConversations(cursor, limit, assistantId, assistantModel);
  }

  @override
  Future<GetConversationsHistoryResponse> getMessages(
    String conversationId,
    String? cursor,
    int? limit,
    String assistantId,
    String assistantModel,
  ) {
    return _aiChatService.getMessages(conversationId, cursor, limit, assistantId, assistantModel);
  }

  @override
  Future<AIChatResponse> sendMessage(String content, String conversationId, List<MessageModel> messages, AssistantModel assistant) {
    return _aiChatService.sendMessage(
      {
        "content": content,
        "metadata": {
          "conversation": {"id": conversationId, "messages": messages.map((e) => e.toJson()).toList()},
        },
        "assistant": assistant.toJson(),
      },
    );
  }
}
