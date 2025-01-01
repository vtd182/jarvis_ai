import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../locator.dart';
import '../../../../prompt/app/ui/widget/use_prompt_bottom_sheet.dart';
import 'chat_page_viewmodel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends BaseViewState<ChatPage, ChatPageViewModel> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleInputChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleInputChange);
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleInputChange() {
    final text = _messageController.text;
    viewModel.showPromptOptions.value = text.trim() == '/';
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.messages.length + (viewModel.isModelAnswering.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == viewModel.messages.length && viewModel.isModelAnswering.value) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Model đang trả lời...",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: LoadingAnimationWidget.waveDots(
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final message = viewModel.messages[index];
                      final isUserMessage = message.role == 'user';

                      return Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (!isUserMessage)
                              Text(
                                message.assistant.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: isUserMessage ? Colors.blue.shade100 : Colors.grey.shade200,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isUserMessage ? const Radius.circular(16) : Radius.zero,
                                  bottomRight: isUserMessage ? Radius.zero : const Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isUserMessage ? Colors.black : Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (viewModel.showPromptOptions.value)
              // Phần chọn prompt hiển thị dạng ListView dọc
              Container(
                color: Colors.grey.shade100,
                height: 200, // Chiều cao cố định
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: viewModel.listPrompt.length,
                  itemBuilder: (context, index) {
                    final prompt = viewModel.listPrompt[index].title;
                    return ListTile(
                      title: Text(prompt!),
                      onTap: () {
                        Get.bottomSheet(
                          UsePromptBottomSheet(
                            promptItem: viewModel.listPrompt[index],
                            onMessageSent: (message) {
                              viewModel.sendMessage(message);
                            },
                          ),
                          isScrollControlled: true,
                        );
                        viewModel.showPromptOptions.value = false;
                      },
                    );
                  },
                ),
              ),
            // Bottom Navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.black),
                    onPressed: () {
                      // Xử lý camera
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.black),
                    onPressed: () {
                      // Xử lý thư viện
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder, color: Colors.black),
                    onPressed: () {
                      // Xử lý folder
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Tin nhắn",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () {
                      final content = _messageController.text.trim();
                      if (content.isNotEmpty) {
                        viewModel.sendMessage(content);
                        _messageController.clear();
                        viewModel.showPromptOptions.value = false;
                      }
                    },
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
  ChatPageViewModel createViewModel() {
    return locator<ChatPageViewModel>();
  }
}
