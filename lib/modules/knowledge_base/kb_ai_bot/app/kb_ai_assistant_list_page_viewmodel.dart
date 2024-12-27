import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/shared/kb_ai_assistant_info.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_list_ai_assistants_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class KBAIAssistantListPageViewModel extends AppViewModel {
  final GetListAIAssistantsUseCase _getListAIAssistantsUseCase;
  KBAIAssistantListPageViewModel(this._getListAIAssistantsUseCase);
  final _query = Rx<String>("");
  final _orderField = Rx<String>("createdAt");
  final _order = Rx<String>("DESC");
  final _offset = Rx<int>(0);
  final _limit = Rx<int>(10);
  final _isFavorite = Rx<bool>(false);
  final _isPublished = Rx<bool>(false);
  final _kBAIAssistantList = RxList<KBAIAssistant>([]);
  final _isHasNext = Rx<bool>(false);

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
    _isHasNext.value = result.meta.hasNext;
    _kBAIAssistantList.addAll(result.data);
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
          onConfirm: (name, description) {
            print('Name: $name, Description: $description');
          },
        );
      },
    );
  }
}
