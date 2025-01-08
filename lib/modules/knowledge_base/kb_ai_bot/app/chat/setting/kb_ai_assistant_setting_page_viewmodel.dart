import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:jarvis_ai/helpers/utils.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/shared/kb_ai_assistant_info.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/events/kb_ai_delete_event.dart';
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

  Future<void> onRefresh() async {
    await getAssistantById(assistantId);
  }

  Future<void> showUpdateAssistantDialog(KBAIAssistant assistant) async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return KBAIAssistantInfo(
          title: 'Update Assistant',
          initialName: assistant.assistantName,
          initialDescription: assistant.description,
          onConfirm: (name, description, _) async {
            await showLoading();
            final success = await run(
              () => _updateAIAssistantUseCase.run(
                assistantId: assistant.id,
                assistantName: name,
                instructions: "",
                description: description,
              ),
            );
            await hideLoading();
            if (success) {
              showToast("Update Assistant Success");
              await onRefresh();
            }
          },
        );
      },
    );
  }

  Future<void> showUpdateInstructionsDialog(KBAIAssistant assistant) async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return KBAIAssistantInfo(
          title: 'Update Instructions',
          isInstructionsUpdate: true,
          initialInstructions: assistant.instructions,
          onConfirm: (_, __, instructions) async {
            await showLoading();
            final success = await run(
              () => _updateAIAssistantUseCase.run(
                assistantId: assistant.id,
                assistantName: assistant.assistantName,
                instructions: instructions,
                description: assistant.description ?? "",
              ),
            );
            await hideLoading();
            if (success) {
              showToast("Update Assistant Success");
              await onRefresh();
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
      await showLoading();
      final success = await run(() async {
        delete = await _deleteAIAssistantByIdUseCase.run(assistantId: assistant.id);
      });
      await hideLoading();
      if (success && delete == "true") {
        locator<EventBus>().fire(const KBAIDeleteEvent());
        backPageOrHome();
        showToast("Delete Assistant Success");
        await onRefresh();
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
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
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
