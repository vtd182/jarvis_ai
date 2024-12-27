import 'package:flutter/material.dart';

class KBAIAssistantChatPage extends StatefulWidget {
  final String assistantId;

  const KBAIAssistantChatPage({super.key, required this.assistantId});

  @override
  State<KBAIAssistantChatPage> createState() => _KBAIAssistantChatPageState();
}

class _KBAIAssistantChatPageState extends State<KBAIAssistantChatPage> {
  final TextEditingController _textController = TextEditingController();

  void _sendMessage() {
    // Thực hiện gửi tin nhắn
    print('Message sent: ${_textController.text}');
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trợ lý AI (${widget.assistantId})"),
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
    );
  }
}
