import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_message.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_thread.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/ask_to_kb_ai_assistant_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/create_ai_assistant_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/create_kb_ai_thread_for_assistant_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/delete_ai_assistant_by_id_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_ai_assistant_by_id_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_list_kb_ai_thread_of_assistant_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_messages_of_thread_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/update_ai_assistant_usecase.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class KBAIAssistantChatPageViewModel extends AppViewModel {
  final GetAIAssistantByIdUseCase _getAIAssistantByIdUseCase;
  final CreateKBAIThreadForAssistantUseCase _createKBAIThreadForAssistantUseCase;
  final GetListKBAIThreadOfAssistantUseCase _getListKBAIThreadOfAssistantUseCase;
  final AskToKBAiAssistantUseCase _askToKBAiAssistantUseCase;
  final GetMessagesOfThreadUseCase _getMessagesOfThreadUseCase;
  final CreateAIAssistantUseCase _createAIAssistantUseCase;
  final DeleteAIAssistantByIdUseCase _deleteAIAssistantByIdUseCase;
  final UpdateAIAssistantUseCase _updateAIAssistantUseCase;
  final _kBAIThreadList = RxList<KBAIThread>([]);
  final _kBAIMessageList = RxList<KBAIMessage>([]);

  final _threadId = Rxn<String?>();

  final _threadQuery = Rx<String>("");
  final _threadOrderField = Rx<String>("createdAt");
  final _threadOrder = Rx<String>("DESC");
  final _threadOffset = Rx<int>(0);
  final _threadLimit = Rx<int>(10);
  final _threadIsHasNext = Rx<bool>(false);

  final _messageQuery = Rx<String>("");
  final _messageOrderField = Rx<String>("createdAt");
  final _messageOrder = Rx<String>("DESC");
  final _messageOffset = Rx<int>(0);
  final _messageLimit = Rx<int>(50);
  final _messageIsHasNext = Rx<bool>(false);
  final _isAnswering = Rx<bool>(false);

  get messages => _kBAIMessageList;

  String get messageQuery => _messageQuery.value;
  set messageQuery(String value) => _messageQuery.value = value;

  String get messageOrderField => _messageOrderField.value;
  set messageOrderField(String value) => _messageOrderField.value = value;

  String get messageOrder => _messageOrder.value;
  set messageOrder(String value) => _messageOrder.value = value;

  int get messageOffset => _messageOffset.value;
  set messageOffset(int value) => _messageOffset.value = value;

  int get messageLimit => _messageLimit.value;
  set messageLimit(int value) => _messageLimit.value = value;

  bool get isAnswering => _isAnswering.value;
  set isAnswering(bool value) => _isAnswering.value = value;

  bool get messageIsHasNext => _messageIsHasNext.value;
  set messageIsHasNext(bool value) => _messageIsHasNext.value = value;

  set threadId(String? value) {
    if (value == _threadId.value) return;
    _threadId.value = value;
    if (_kBAIMessageList.isNotEmpty) {
      _kBAIMessageList.clear();
    }
    getMessages();
  }

  Future<void> onRefreshThread() async {
    _threadOffset.value = 0;
    await loadKBAIThreads();
  }

  Future<void> getMessages() async {
    if (_threadId.value == null) return;
    final res = await _getMessagesOfThreadUseCase.run(
      openAiThreadId: _threadId.value!,
      query: messageQuery,
      order: messageOrder,
      orderField: messageOrderField,
      offset: messageOffset,
      limit: messageLimit,
    );
    if (messageOffset == 0) {
      _kBAIMessageList.assignAll(res);
    } else {
      _kBAIMessageList.addAll(res);
    }
    if (res.length < messageLimit) {
      messageIsHasNext = false;
    }
  }

  String? get threadId => _threadId.value;

  set threadQuery(String value) => _threadQuery.value = value;
  String get threadQuery => _threadQuery.value;

  set threadOrderField(String value) => _threadOrderField.value = value;
  String get threadOrderField => _threadOrderField.value;

  set threadOrder(String value) => _threadOrder.value = value;
  String get threadOrder => _threadOrder.value;

  set threadOffset(int value) => _threadOffset.value = value;
  int get threadOffset => _threadOffset.value;

  set threadLimit(int value) => _threadLimit.value = value;
  int get threadLimit => _threadLimit.value;

  List<KBAIThread> get kBAIThreadList => _kBAIThreadList.toList();
  bool get isHasNext => _threadIsHasNext.value;

  KBAIAssistantChatPageViewModel(
    this._getAIAssistantByIdUseCase,
    this._createKBAIThreadForAssistantUseCase,
    this._getListKBAIThreadOfAssistantUseCase,
    this._askToKBAiAssistantUseCase,
    this._getMessagesOfThreadUseCase,
    this._createAIAssistantUseCase,
    this._deleteAIAssistantByIdUseCase,
    this._updateAIAssistantUseCase,
  );

  final _assistantId = Rx<String>("");
  String get assistantId => _assistantId.value;
  set assistantId(String value) {
    _assistantId.value = value;
    if (_kBAIThreadList.isNotEmpty) {
      _kBAIThreadList.clear();
    }
  }

  final _assistant = Rxn<KBAIAssistant>();
  KBAIAssistant? get assistant => _assistant.value;

  Future<void> getAssistantById(String assistantId) async {
    final assistant = await _getAIAssistantByIdUseCase.run(assistantId: assistantId);
    _assistant.value = assistant;
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<Unit> _init() async {
    await getAssistantById(assistantId);
    await loadKBAIThreads();
    return unit;
  }

  Future<Unit> loadKBAIThreads() async {
    final result = await _getListKBAIThreadOfAssistantUseCase.run(
      assistantId: assistantId,
      query: threadQuery,
      order: threadOrder,
      orderField: threadOrderField,
      offset: threadOffset,
      limit: threadLimit,
    );
    if (threadOffset == 0) {
      _kBAIThreadList.assignAll(result.data);
    } else {
      _kBAIThreadList.addAll(result.data);
    }
    _threadIsHasNext.value = result.meta.hasNext;
    return unit;
  }

  Future<void> onLoadMoreThreads() async {
    threadOffset = threadOffset + threadLimit;
    await loadKBAIThreads();
  }

  Future<void> onLoadMoreMessages() async {
    messageOffset = messageOffset + messageLimit;
    await getMessages();
  }

  Future<void> askToAssistant(String message) async {
    if (threadId == null) return;
    isAnswering = true;
    await _askToKBAiAssistantUseCase.run(
      assistantId: assistantId,
      message: message,
      openAiThreadId: threadId!,
      additionalInstruction: "",
    );
    isAnswering = false;
    await getMessages();
  }

  Future<void> createNewThread(String message) async {
    final thread = await _createKBAIThreadForAssistantUseCase.run(
      assistantId: assistantId,
      firstMessage: message,
    );
    threadId = thread.openAiThreadId;
  }
}
