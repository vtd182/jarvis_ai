import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/shared/kb_ai_assistant_info.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/delete_ai_assistant_by_id_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_ai_assistant_by_id_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/update_ai_assistant_usecase.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class KBAIAssistantSettingPageViewModel extends AppViewModel {
  final GetAIAssistantByIdUseCase _getAIAssistantByIdUseCase;
  final DeleteAIAssistantByIdUseCase _deleteAIAssistantByIdUseCase;
  final UpdateAIAssistantUseCase _updateAIAssistantUseCase;

  String assistantId = "";
  KBAIAssistantSettingPageViewModel(
    this._getAIAssistantByIdUseCase,
    this._deleteAIAssistantByIdUseCase,
    this._updateAIAssistantUseCase,
  );

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
    return unit;
  }

  Future<void> _deleteAssistantById(String assistantId) async {
    await _deleteAIAssistantByIdUseCase.run(assistantId: assistantId);
  }

  Future<void> _updateAssistant({
    required String assistantName,
    required String instructions,
    required String description,
  }) async {
    await _updateAIAssistantUseCase.run(
      assistantId: assistantId,
      assistantName: assistantName,
      instructions: instructions,
      description: description,
    );
  }

  Future<void> showCreateAssistantDialog() async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return KBAIAssistantInfo(
          title: 'Update Assistant',
          initialName: assistant?.assistantName,
          initialDescription: assistant?.description,
          onConfirm: (name, description) {
            print('Name: $name, Description: $description');
          },
        );
      },
    );
  }
}
