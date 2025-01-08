import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/kb_ai_assistant_setting_page_viewmodel.dart';
import 'package:suga_core/suga_core.dart';

import 'knowledge_base_manager/kb_ai_assistant_knowledge_base_manager_page.dart';

class KBAIAssistantSettingPage extends StatefulWidget {
  final String assistantId;

  const KBAIAssistantSettingPage({super.key, required this.assistantId});

  @override
  State<KBAIAssistantSettingPage> createState() => _KBAIAssistantSettingPageState();
}

class _KBAIAssistantSettingPageState extends BaseViewState<KBAIAssistantSettingPage, KBAIAssistantSettingPageViewModel> {
  @override
  loadArguments() {
    viewModel.assistantId = widget.assistantId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Assets.images.imgAssistant.image(
                      width: 100,
                      height: 100,
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () => viewModel.showUpdateAssistantDialog(viewModel.assistant!),
                            child: const Icon(Icons.edit),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Text(
                    viewModel.assistant?.assistantName ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Text(
                    viewModel.assistant?.description ?? '',
                  ),
                ),
                const SizedBox(height: 30),
                _buildOptionRow(
                  title: const Text(
                    "Knowledge Base",
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Get.to(
                      () => KBAIAssistantKnowledgeBaseManagerPage(
                        assistantId: widget.assistantId,
                      ),
                    );
                  },
                ),
                _buildOptionRow(
                  title: const Text(
                    "Instructions",
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    viewModel.showUpdateInstructionsDialog(viewModel.assistant!);
                  },
                ),
                _buildOptionRow(
                  title: const Text(
                    "Delete Assistant",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    viewModel.showDeleteAssistantDialog(viewModel.assistant!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionRow({required Widget title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title,
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  KBAIAssistantSettingPageViewModel createViewModel() {
    return locator<KBAIAssistantSettingPageViewModel>();
  }
}
