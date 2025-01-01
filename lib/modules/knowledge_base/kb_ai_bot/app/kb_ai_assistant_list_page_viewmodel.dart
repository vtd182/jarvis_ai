import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/shared/kb_ai_assistant_info.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/create_ai_assistant_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/delete_ai_assistant_by_id_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_list_ai_assistants_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/update_ai_assistant_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class KBAIAssistantListPageViewModel extends AppViewModel {
  final GetListAIAssistantsUseCase _getListAIAssistantsUseCase;
  final CreateAIAssistantUseCase _createAIAssistantUseCase;
  final DeleteAIAssistantByIdUseCase _deleteAIAssistantByIdUseCase;
  final UpdateAIAssistantUseCase _updateAIAssistantUseCase;

  KBAIAssistantListPageViewModel(
    this._getListAIAssistantsUseCase,
    this._createAIAssistantUseCase,
    this._deleteAIAssistantByIdUseCase,
    this._updateAIAssistantUseCase,
  );

  final ValueNotifier<String?> _openItemIdNotifier = ValueNotifier<String?>(null);
  final _query = Rx<String>("");
  final _orderField = Rx<String>("createdAt");
  final _order = Rx<String>("DESC");
  final _offset = Rx<int>(0);
  final _limit = Rx<int>(10);
  final _isFavorite = Rx<bool>(false);
  final _isPublished = Rx<bool>(false);
  final _kBAIAssistantList = RxList<KBAIAssistant>([]);
  final _isHasNext = Rx<bool>(false);
  final _isLoadingMore = Rx<bool>(false);

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

  set isFavorite(bool value) => _isFavorite.value = value;
  bool get isFavorite => _isFavorite.value;

  set isPublished(bool value) => _isPublished.value = value;
  bool get isPublished => _isPublished.value;

  List<KBAIAssistant> get kBAIAssistantList => _kBAIAssistantList.toList();
  bool get isHasNext => _isHasNext.value;

  Future<Unit> loadAIAssistants() async {
    final result = await _getListAIAssistantsUseCase.run(
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
      isFavorite: isFavorite,
      isPublished: isPublished,
    );
    if (offset == 0) {
      _kBAIAssistantList.assignAll(result.data);
    } else {
      _kBAIAssistantList.addAll(result.data);
    }
    _isHasNext.value = result.meta.hasNext;
    return unit;
  }

  @override
  void initState() {
    loadAIAssistants();
    print("KBAIAssistantListPageViewModel initState");
    print(kBAIAssistantList);
    super.initState();
  }

  Future<void> showCreateAssistantDialog() async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return KBAIAssistantInfo(
          title: 'Create Assistant',
          initialName: null,
          initialDescription: null,
          onConfirm: (name, description) async {
            final success = await run(
              () => _createAIAssistantUseCase.run(
                assistantName: name,
                instructions: "",
                description: description,
              ),
            );
            if (success) {
              showToast("Create Assistant Success");
              await onRefresh();
            } else {
              showToast("Create Assistant Failed");
            }
          },
        );
      },
    );
  }

  Future<void> onRefresh() async {
    offset = 0;
    await loadAIAssistants();
  }

  Future<void> onLoadingMore() async {
    isLoadingMore = true;
    offset += limit;
    await loadAIAssistants();
    isLoadingMore = false;
  }

  Future<void> showUpdateAssistantDialog(KBAIAssistant assistant) async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return KBAIAssistantInfo(
          title: 'Update Assistant',
          initialName: assistant.assistantName,
          initialDescription: assistant.description,
          onConfirm: (name, description) async {
            final success = await run(
              () => _updateAIAssistantUseCase.run(
                assistantId: assistant.id,
                assistantName: name,
                instructions: "",
                description: description,
              ),
            );
            if (success) {
              showToast("Update Assistant Success");
              await onRefresh();
            } else {
              showToast("Update Assistant Failed");
            }
          },
        );
      },
    );
  }

  Future<void> showDeleteAssistantDialog(KBAIAssistant assistant) async {
    final confirm = await showConfirmDialog(
      title: "Delete Assistant",
      content: "Are you sure you want to delete this assistant?",
    );
    if (confirm) {
      String delete = "";
      final success = await run(() async {
        delete = await _deleteAIAssistantByIdUseCase.run(assistantId: assistant.id);
      });
      if (success && delete == "true") {
        showToast("Delete Assistant Success");
        openItemIdNotifier.value = null;
        await onRefresh();
      } else {
        showToast("Delete Assistant Failed");
      }
    }
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
}