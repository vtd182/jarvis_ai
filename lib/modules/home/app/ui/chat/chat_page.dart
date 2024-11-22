import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../locator.dart';
import 'chat_page_viewmodel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends BaseViewState<ChatPage, ChatPageViewModel> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Nội dung chính
          Expanded(
            child: Obx(() {
              final chatMessages = viewModel.messages;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatMessages[index];
                  final isUserMessage = message.role == 'user';

                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!isUserMessage) // Tên model chỉ hiển thị với tin nhắn từ model
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
            }),
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
                    controller: _messageController,
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
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.black),
                  onPressed: () {
                    // Xử lý mic
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    final content = _messageController.text.trim();
                    if (content.isNotEmpty) {
                      viewModel.sendMessage(content);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  ChatPageViewModel createViewModel() {
    return locator<ChatPageViewModel>();
  }
}
