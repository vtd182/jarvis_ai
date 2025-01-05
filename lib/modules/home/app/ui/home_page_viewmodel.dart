import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/enums/assistant.dart';
import 'package:jarvis_ai/modules/home/domain/models/conversation_summary_model.dart';
import 'package:jarvis_ai/modules/home/domain/models/subscription_usage.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_history_conversation_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_subcription_usage_use_case.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_token_usage_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/domain/usecase/knowledge_base_sign_in_usecase.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../core/abstracts/app_view_model.dart';
import '../../../auth/app/ui/widgets/session_expired_widget.dart';
import '../../../auth/domain/events/session_expired_event.dart';
import '../../../auth/domain/models/user_model.dart';
import '../../domain/models/token_usage.dart';

@lazySingleton
class HomePageViewModel extends AppViewModel {
  final GetTokenUsageUseCase _getTokenUsageUseCase;
  final GetSubscriptionUsageUseCase _getSubscriptionUsageUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetHistoryConversationUseCase _getHistoryConversationUseCase;
  final KnowledgeBaseSignInUseCase _knowledgeBaseSignInUseCase;
  StreamSubscription? _sessionExpiredEventListener;

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

  final _query = Rx<String>("");
  final _orderField = Rx<String>("createdAt");
  final _order = Rx<String>("DESC");
  final _offset = Rx<int>(0);
  final _limit = Rx<int>(10);
  final _isHasNext = Rx<bool>(false);
  final _isLoadingMore = Rx<bool>(false);

  set isLoadingMore(bool value) => _isLoadingMore.value = value;
  bool get isLoadingMore => _isLoadingMore.value;

  set query(String value) => _query.value = value;
  String get query => _query.value;

  set orderField(String value) => _orderField.value = value;
  String get orderField => _orderField.value;

  set order(String value) => _order.value = value;
  String get order => _order.value;

  set offset(int value) => _offset.value = value;
  int get offset => _offset.value;

  set limit(int value) => _limit.value = value;
  int get limit => _limit.value;

  bool get isHasNext => _isHasNext.value;
  set isHasNext(bool value) => _isHasNext.value = value;

  Rx<TokenUsage> tokenUsage = TokenUsage(
    availableTokens: 0,
    unlimited: false,
    totalTokens: 0,
    date: DateTime.now(),
  ).obs;

  Rx<SubscriptionUsage> subscriptionUsage = SubscriptionUsage(
    name: '',
    daily: 0,
    monthly: 0,
    annually: 0,
  ).obs;

  Rx<UserModel> currentUser = UserModel(id: '', email: '', username: '', roles: []).obs;

  HomePageViewModel(
    this._getTokenUsageUseCase,
    this._getCurrentUserUseCase,
    this._getHistoryConversationUseCase,
    this._knowledgeBaseSignInUseCase,
    this._getSubscriptionUsageUseCase,
  );

  Future<Unit> onSignInKB() async {
    final token = await SPref.instance.getKBAccessToken() ?? "";
    final expiresAt = await SPref.instance.getKBExpiresAt();
    final expiresAtDate = DateTime.fromMillisecondsSinceEpoch(int.tryParse(expiresAt.toString()) ?? 0);
    if (token == "" || expiresAtDate.isAfter(DateTime.now())) {
      final appToken = await SPref.instance.getAccessToken();
      if (appToken != "") {
        await run(
          () async {
            await _knowledgeBaseSignInUseCase.run(token: appToken!);
          },
        );
      }
    }
    return unit;
  }

  Future<Unit> getTokenUsage() async {
    await run(() async {
      final tokenUsage = await _getTokenUsageUseCase.run();
      this.tokenUsage.value = tokenUsage;
    });
    return unit;
  }

  Future<Unit> getSubscriptionUsage() async {
    await run(() async {
      final subscriptionUsage = await _getSubscriptionUsageUseCase.run();
      this.subscriptionUsage.value = subscriptionUsage;
    });
    return unit;
  }

  Future<UserModel> getCurrentUser() async {
    await run(() async {
      final user = await _getCurrentUserUseCase.run();
      currentUser.value = user;
    });
    return currentUser.value;
  }

  @override
  void initState() {
    getTokenUsage();
    getSubscriptionUsage();
    getCurrentUser();
    getHistoryConversation();
    _sessionExpiredEventListener = locator<EventBus>().on<SessionExpiredEvent>().listen((event) {
      Get.bottomSheet(
        const SessionExpiredWidget(),
        isDismissible: false,
        isScrollControlled: false,
        enableDrag: false,
        elevation: 1,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
      );
    });
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
      conversationSummaries.assignAll(res.items);
    }
    isHasNext = res.hasMore;
  }

  Future<void> onNavItemTapped(int index) async {
    if (index == 2 || index == 3) {
      await onSignInKB();
    }
    selectedIndex = index;
    Get.back();
  }

  Future<void> onRefreshDrawer() async {
    await getHistoryConversation();
    await getTokenUsage();
  }
}
