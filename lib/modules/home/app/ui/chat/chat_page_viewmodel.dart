import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/home/domain/models/assistant_model.dart';
import 'package:jarvis_ai/modules/home/domain/models/get_conversation_history_response.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/do_ai_chat_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_message_in_conversation_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/send_message_in_old_conversation_usecase.dart';

import '../../../domain/enums/assistant.dart';
import '../../../domain/models/message_model.dart';

@injectable
class ChatPageViewModel extends AppViewModel {
  final DoAIChatUseCase _doAIChatUseCase;
  final SendMessageInOldConversationUseCase _sendMessageInOldConversationUseCase;
  final GetMessageInConversationUseCase _getMessageInConversationUseCase;
  final messages = <MessageModel>[].obs;
  final conversationId = Rxn<String?>();

  ChatPageViewModel(
    this._doAIChatUseCase,
    this._sendMessageInOldConversationUseCase,
    this._getMessageInConversationUseCase,
  );

  Future<void> getOldMessages() async {
    final res = await _getMessageInConversationUseCase.run(
      conversationId: "fd2f74fd-02f9-4a25-835c-70ea9608e0cb",
      cursor: null,
      limit: null,
      assistantId: Assistant.gpt_4o.value,
      assistantModel: 'dify',
    );
    if (res.items.isNotEmpty) {
      messages.value = res.toMessageModels();
    }
    print("messages: ${messages.value}");
  }

  Future<void> sendMessage(String content) async {
    final res = await _sendMessageInOldConversationUseCase.run(
      content: content,
      conversationId: "fd2f74fd-02f9-4a25-835c-70ea9608e0cb",
      messages: messages,
      assistant: AssistantModel(
        id: Assistant.claude_3_haiku_20240307,
        model: "dify",
        name: "Claude 3 Haiku",
      ),
    );
    messages.add(
      MessageModel(
        role: "user",
        content: content,
        assistant: AssistantModel(
          id: Assistant.gpt_4o,
          model: "dify",
          name: "GPT-4o mini",
        ),
      ),
    );
    if (res != null) {
      messages.add(
        MessageModel(
          role: "model",
          content: res.message,
          assistant: AssistantModel(
            id: Assistant.gpt_4o,
            model: "dify",
            name: "GPT-4o mini",
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getOldMessages();
  }
}
