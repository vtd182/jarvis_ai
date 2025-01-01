import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/enums/assistant.dart';
import 'package:jarvis_ai/modules/home/domain/models/conversation_summary_model.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_history_conversation_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_token_usage_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/domain/usecase/knowledge_base_sign_in_usecase.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../core/abstracts/app_view_model.dart';
import '../../../auth/domain/models/user_model.dart';
import '../../domain/models/token_usage.dart';

@lazySingleton
class HomePageViewModel extends AppViewModel {
  final GetTokenUsageUseCase _getTokenUsageUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetHistoryConversationUseCase _getHistoryConversationUseCase;
  final KnowledgeBaseSignInUseCase _knowledgeBaseSignInUseCase;

  final conversationSummaries = <ConversationSummaryModel>[].obs;
  final RxInt _selectedIndex = 0.obs;
  final currentAssistant = Assistant.gpt_4o_mini.obs;
  final models = <Assistant>[
    Assistant.gpt_4o_mini,
    Assistant.gpt_4o,
    Assistant.claude_3_haiku_20240307,
    Assistant.claude_3_5_sonet_20240620,
    Assistant.gemini_1_5_flash_latest,
    Assistant.gemini_1_5_pro_latest,
  ].obs;
  set selectedIndex(int index) => _selectedIndex.value = index;
  int get selectedIndex => _selectedIndex.value;

  Rx<TokenUsage> tokenUsage = TokenUsage(
    availableTokens: 0,
    unlimited: false,
    totalTokens: 0,
    date: DateTime.now(),
  ).obs;

  Rx<UserModel> currentUser = UserModel(id: '', email: '', username: '', roles: []).obs;

  HomePageViewModel(
    this._getTokenUsageUseCase,
    this._getCurrentUserUseCase,
    this._getHistoryConversationUseCase,
    this._knowledgeBaseSignInUseCase,
  );

  Future<Unit> onSignInKB() async {
    final token = await SPref.instance.getKBAccessToken();
    // if (token != "") {
    final appToken = await SPref.instance.getAccessToken();
    if (appToken != "") {
      await run(
        () async {
          await _knowledgeBaseSignInUseCase.run(token: appToken!);
        },
      );
    }
    // }
    return unit;
  }

  Future<Unit> getTokenUsage() async {
    await run(() async {
      final tokenUsage = await _getTokenUsageUseCase.run();
      this.tokenUsage.value = tokenUsage;
    });
    return unit;
  }

  Future<UserModel> getCurrentUser() async {
    return _getCurrentUserUseCase.run();
  }

  @override
  void initState() {
    getTokenUsage();
    getHistoryConversation();
    super.initState();
  }

  Future<void> getHistoryConversation() async {
    final res = await _getHistoryConversationUseCase.run(
      cursor: null,
      limit: null,
      assistantId: Assistant.gpt_4o_mini.value,
      assistantModel: 'dify',
    );
    if (res.items.isNotEmpty) {
      conversationSummaries.value = res.items;
    }
  }

  Future<void> onNavItemTapped(int index) async {
    if (index == 2) {
      await onSignInKB();
    }
    selectedIndex = index;
    Get.back();
  }
}
