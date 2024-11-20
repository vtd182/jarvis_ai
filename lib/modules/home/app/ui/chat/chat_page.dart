import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? _selectedModel = "GPT-3"; // Model AI hiện tại
  final List<String> _aiModels = ["GPT-3", "GPT-4", "Bard", "Claude"]; // Danh sách model

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Nội dung chính
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tôi có thể giúp gì cho bạn?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildActionButton(Icons.image, "Tạo hình ảnh", Colors.green),
                    _buildActionButton(Icons.article, "Tóm tắt văn bản", Colors.orange),
                    _buildActionButton(Icons.lightbulb, "Lên kế hoạch", Colors.yellow),
                    _buildActionButton(Icons.more_horiz, "Thêm", Colors.grey),
                  ],
                ),
              ],
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
                    // Xử lý gửi
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
