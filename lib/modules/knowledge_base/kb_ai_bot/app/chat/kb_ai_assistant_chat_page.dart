import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/kb_ai_assistant_chat_page_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/kb_ai_assistant_setting_page.dart';
import 'package:suga_core/suga_core.dart';

class KBAIAssistantChatPage extends StatefulWidget {
  final String assistantId;

  const KBAIAssistantChatPage({super.key, required this.assistantId});

  @override
  State<KBAIAssistantChatPage> createState() => _KBAIAssistantChatPageState();
}

class _KBAIAssistantChatPageState extends BaseViewState<KBAIAssistantChatPage, KBAIAssistantChatPageViewModel> {
  final TextEditingController _textController = TextEditingController();

  @override
  loadArguments() {
    viewModel.assistantId = widget.assistantId;
  }

  void _sendMessage() {
    print('Message sent: ${_textController.text}');
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(viewModel.assistant?.assistantName ?? ''),
          centerTitle: true,
          // setting icon
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => KBAIAssistantSettingPage(assistantId: widget.assistantId), transition: Transition.downToUp);
              },
              icon: const Icon(
                Icons.info_outline,
                color: Color(0xFF1677FF),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.mail_outline, size: 100, color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Trợ lý AI của bạn',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sử dụng không gian này để gửi tin nhắn cho chính bạn',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: "Nhập tin nhắn",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  KBAIAssistantChatPageViewModel createViewModel() {
    return locator<KBAIAssistantChatPageViewModel>();
  }
}
