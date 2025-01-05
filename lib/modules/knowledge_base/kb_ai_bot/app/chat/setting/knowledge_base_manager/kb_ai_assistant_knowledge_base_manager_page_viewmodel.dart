import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/get_knowledge_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/knowledge_base_manager/widgets/knowledge_base_list_for_import.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_knowledge.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_list_knowledge_of_assistant_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/import_knowledge_to_assistant_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/remove_knowledge_from_assistant_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class KBAIAssistantKnowledgeBaseManagerPageViewModel extends AppViewModel {
  final GetKnowledgeUsecase _getKnowledgeUsecase;
  final ImportKnowledgeToAssistantUseCase _importKnowledgeToAssistantUseCase;
  final RemoveKnowledgeFromAssistantUseCase _removeKnowledgeFromAssistantUseCase;
  final GetListKnowledgeOfAssistantUseCase _getListKnowledgeOfAssistantUseCase;

  KBAIAssistantKnowledgeBaseManagerPageViewModel(
    this._getKnowledgeUsecase,
    this._importKnowledgeToAssistantUseCase,
    this._removeKnowledgeFromAssistantUseCase,
    this._getListKnowledgeOfAssistantUseCase,
  );

  final RxMap<String, ImportState> itemImportStates = <String, ImportState>{}.obs;
  final assistantId = Rx<String>("");

  final ValueNotifier<String?> _openItemIdNotifier = ValueNotifier<String?>(null);
  final _query = Rx<String>("");
  final _orderField = Rx<String>("createdAt");
  final _order = Rx<String>("DESC");
  final _offset = Rx<int>(0);
  final _limit = Rx<int>(10);
  final _kBAIKnowledgeImportedList = RxList<KBAIKnowledge>([]);
  final _isHasNext = Rx<bool>(false);
  final _isLoadingMore = Rx<bool>(false);

  final _bottomSheetQuery = Rx<String>("");
  final _bottomSheetOrderField = Rx<String>("createdAt");
  final _bottomSheetOrder = Rx<String>("DESC");
  final _bottomSheetOffset = Rx<int>(0);
  final _bottomSheetLimit = Rx<int>(10);
  final _kBAIKnowledgeList = RxList<ResponseGetKl>([]);
  final _bottomSheetIsHasNext = Rx<bool>(false);
  final _bottomSheetIsLoadingMore = Rx<bool>(false);

  set bottomSheetQuery(String value) => _bottomSheetQuery.value = value;
  String get bottomSheetQuery => _bottomSheetQuery.value;

  set bottomSheetOrderField(String value) => _bottomSheetOrderField.value = value;
  String get bottomSheetOrderField => _bottomSheetOrderField.value;

  set bottomSheetOrder(String value) => _bottomSheetOrder.value = value;
  String get bottomSheetOrder => _bottomSheetOrder.value;

  set bottomSheetOffset(int value) => _bottomSheetOffset.value = value;
  int get bottomSheetOffset => _bottomSheetOffset.value;

  set bottomSheetLimit(int value) => _bottomSheetLimit.value = value;
  int get bottomSheetLimit => _bottomSheetLimit.value;

  set bottomSheetIsHasNext(bool value) => _bottomSheetIsHasNext.value = value;
  bool get bottomSheetIsHasNext => _bottomSheetIsHasNext.value;

  set bottomSheetIsLoadingMore(bool value) => _bottomSheetIsLoadingMore.value = value;
  bool get bottomSheetIsLoadingMore => _bottomSheetIsLoadingMore.value;

  List<ResponseGetKl> get kBAIKnowledgeList => _kBAIKnowledgeList.toList();

  ValueNotifier<String?> get openItemIdNotifier => _openItemIdNotifier;

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

  List<KBAIKnowledge> get kBAIKnowledgeImportedList => _kBAIKnowledgeImportedList.toList();
  bool get isHasNext => _isHasNext.value;

  Future<void> importKnowledgeToAssistant(String knowledgeId) async {
    itemImportStates[knowledgeId] = ImportState.loading;
    try {
      final result = await _importKnowledgeToAssistantUseCase.run(
        assistantId: assistantId.value,
        knowledgeId: knowledgeId,
      );
      if (result == "true") {
        itemImportStates[knowledgeId] = ImportState.success;
        await onRefresh();
      } else {
        itemImportStates[knowledgeId] = ImportState.error;
      }
    } catch (e) {
      itemImportStates[knowledgeId] = ImportState.error;
    }
  }

  Future<Unit> removeKnowledgeFromAssistant(String knowledgeId) async {
    await showLoading();
    try {
      final result = await _removeKnowledgeFromAssistantUseCase.run(
        assistantId: assistantId.value,
        knowledgeId: knowledgeId,
      );
      if (result == "true") {
        await onRefresh();
        showToast("Remove knowledge successfully");
        openItemIdNotifier.value = null;
        await hideLoading();
      } else {
        showToast("Remove knowledge failed");
      }
    } catch (e) {
      await hideLoading();
      showToast("Remove knowledge failed");
    }

    return unit;
  }

  Future<Unit> loadBBAIKnowledgeImportedList() async {
    final result = await _getListKnowledgeOfAssistantUseCase.run(
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
      assistantId: assistantId.value,
    );
    if (offset == 0) {
      _kBAIKnowledgeImportedList.assignAll(result.data);
    } else {
      _kBAIKnowledgeImportedList.addAll(result.data);
    }
    _isHasNext.value = result.meta.hasNext;
    return unit;
  }

  Future<Unit> loadBBAIKnowledgeList() async {
    final result = await _getKnowledgeUsecase.run(
      queries: RequestKnowledgeModel(
        limit: bottomSheetLimit,
        offset: bottomSheetOffset,
        q: query,
        order: bottomSheetOrder,
        orderField: bottomSheetOrderField,
      ),
    );
    if (offset == 0) {
      _kBAIKnowledgeList.assignAll(result.data);
    } else {
      _kBAIKnowledgeList.addAll(result.data);
    }
    _isHasNext.value = result.meta.hasNext;
    return unit;
  }

  @override
  void initState() {
    loadBBAIKnowledgeImportedList();
    loadBBAIKnowledgeList();
    super.initState();
  }

  Future<void> onRefresh() async {
    offset = 0;
    await loadBBAIKnowledgeImportedList();
  }

  Future<void> onLoadingMore() async {
    isLoadingMore = true;
    offset += limit;
    await loadBBAIKnowledgeImportedList();
    isLoadingMore = false;
  }

  showConfirmDialog({required String title, required String content}) {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  showImportDialog() {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: KnowledgeBaseListForImport(viewModel: this),
          ),
        );
      },
    );
  }

  Future<void> onSearch(String value) async {
    query = value;
    offset = 0;
    await loadBBAIKnowledgeImportedList();
  }

  Future<void> onBottomSheetSearch(String value) async {
    bottomSheetQuery = value;
    bottomSheetOffset = 0;
    await loadBBAIKnowledgeList();
  }

  Future<void> onBottomSheetRefresh() async {
    bottomSheetOffset = 0;
    bottomSheetQuery = "";
    itemImportStates.clear();
    await loadBBAIKnowledgeList();
  }

  Future<void> onBottomSheetLoadingMore() async {
    bottomSheetIsLoadingMore = true;
    bottomSheetOffset += bottomSheetLimit;
    await loadBBAIKnowledgeList();
    bottomSheetIsLoadingMore = false;
  }

  Future<void> onShowConfirmDeleteDialog(String id) {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Remove"),
          content: const Text("Do you want to remove this knowledge?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await removeKnowledgeFromAssistant(id);
                Get.back(result: true);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}

enum ImportState { idle, loading, success, error }
