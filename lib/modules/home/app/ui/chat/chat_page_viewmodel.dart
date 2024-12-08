import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page_viewmodel.dart';
import 'package:jarvis_ai/modules/home/domain/models/assistant_model.dart';
import 'package:jarvis_ai/modules/home/domain/models/get_conversation_history_response.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/do_ai_chat_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_message_in_conversation_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/send_message_in_old_conversation_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/get_prompt_usecase.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../locator.dart';
import '../../../../prompt/domain/model/prompt_item_model.dart';
import '../../../../prompt/domain/model/prompts_response_model.dart';
import '../../../domain/enums/assistant.dart';
import '../../../domain/models/message_model.dart';

@lazySingleton
class ChatPageViewModel extends AppViewModel {
  final GetPromptUsecase _getPromptUsecase;
  final DoAIChatUseCase _doAIChatUseCase;
  final SendMessageInOldConversationUseCase _sendMessageInOldConversationUseCase;
  final GetMessageInConversationUseCase _getMessageInConversationUseCase;
  final messages = <MessageModel>[].obs;
  final _conversationId = Rxn<String?>();
  final isLoading = false.obs;
  final showPromptOptions = false.obs;
  final listPrompt = <PromptItemModel>[].obs;

  set conversationId(String? id) {
    if (id == _conversationId.value) return;
    _conversationId.value = id;
    if (messages.isNotEmpty) {
      messages.clear();
    }
    getOldMessages();
  }

  String? get conversationId => _conversationId.value;

  ChatPageViewModel(
    this._getPromptUsecase,
    this._doAIChatUseCase,
    this._sendMessageInOldConversationUseCase,
    this._getMessageInConversationUseCase,
  );

  Future<void> getOldMessages() async {
    if (_conversationId.value == null) return;
    final res = await _getMessageInConversationUseCase.run(
      conversationId: _conversationId.value!,
      cursor: null,
      limit: null,
      assistantId: Assistant.gpt_4o.value,
      assistantModel: 'dify',
    );
    if (res.items.isNotEmpty) {
      messages.addAll(res.toMessageModels());
    }
  }

  Future<void> sendMessage(String content) async {
    final assistant = locator<HomePageViewModel>().currentAssistant.value;
    messages.add(
      MessageModel(
        role: "user",
        content: content,
        assistant: AssistantModel(
          id: assistant,
          model: "dify",
          name: assistant.label,
        ),
        isErrored: false,
      ),
    );
    isLoading.value = true;
    if (_conversationId.value == null) {
      await sendMessageInNewConversation(content, assistant);
    } else {
      await sendMessageInOldConversation(content, assistant);
    }
    isLoading.value = false;
  }

  @override
  void initState() {
    super.initState();
    getPublicPrompt(query: "");
    if (conversationId == null) return;
    getOldMessages();
  }

  void updateTokenUsage(int token) {
    locator<HomePageViewModel>().tokenUsage.value.availableTokens = token;
  }

  Future<void> sendMessageInOldConversation(String content, Assistant assistant) async {
    try {
      final response = await _sendMessageInOldConversationUseCase.run(
        content: content,
        conversationId: _conversationId.value!,
        messages: messages.sublist(0, messages.length - 1),
        assistant: AssistantModel(
          id: assistant,
          model: "dify",
          name: assistant.label,
        ),
      );

      messages.add(
        MessageModel(
          role: "model",
          content: response.message,
          assistant: AssistantModel(
            id: assistant,
            model: "dify",
            name: assistant.label,
          ),
          isErrored: false,
        ),
      );
      updateTokenUsage(response.remainingUsage);
    } catch (e) {
      print(e);
      // todo: handle error
    }
  }

  Future<void> sendMessageInNewConversation(String content, Assistant assistant) async {
    try {
      final response = await _doAIChatUseCase.run(assistant, content);

      messages.add(
        MessageModel(
          role: "model",
          content: response.message,
          assistant: AssistantModel(
            id: assistant,
            model: "dify",
            name: assistant.label,
          ),
          isErrored: false,
        ),
      );
      _conversationId.value = response.conversationId;
      updateTokenUsage(response.remainingUsage);
      await locator<HomePageViewModel>().getHistoryConversation();
    } catch (e) {
      print(e);
      // todo: handle error
    }
  }

  Future<Unit> getPublicPrompt({
    required String query,
    bool isLoadMore = false,
  }) async {
    print("getPublicPrompt");
    try {
      final queries = {
        "query": query,
        "isFavorite": false,
        "isPublic": true,
        "offset": 1,
        "limit": 20,
      };

      final result = await _getPromptUsecase.run(
        queries: queries,
      );

      final promptResponse = PromptsResponseModel.fromJson(result);
      listPrompt.addAll(promptResponse.items ?? []);
    } catch (e) {
      print("Error during getPrompt: $e");
    }
    return unit;
  }
}
