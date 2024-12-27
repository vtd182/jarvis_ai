import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/kb_ai_assistant_setting_page_viewmodel.dart';
import 'package:suga_core/suga_core.dart';

class KBAIAssistantSettingPage extends StatefulWidget {
  final String assistantId;

  const KBAIAssistantSettingPage({super.key, required this.assistantId});

  @override
  State<KBAIAssistantSettingPage> createState() => _KBAIAssistantSettingPageState();
}

class _KBAIAssistantSettingPageState extends BaseViewState<KBAIAssistantSettingPage, KBAIAssistantSettingPageViewModel> {
  bool _isNotificationsEnabled = true;
  bool _isFavorite = false;

  @override
  loadArguments() {
    viewModel.assistantId = widget.assistantId;
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  void _toggleFavorite(bool value) {
    setState(() {
      _isFavorite = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: InkWell(
                        onTap: () async {
                          await viewModel.showCreateAssistantDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
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
                ),
                onTap: () {},
              ),
              _buildOptionRow(
                title: const Text(
                  "Instructions",
                ),
                onTap: () {},
              ),
              _buildOptionRow(
                title: const Text(
                  "Delete Assistant",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
            ],
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
