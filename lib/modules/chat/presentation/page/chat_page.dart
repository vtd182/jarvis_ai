import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/empty_body_message_widget.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/header_chat_widget.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/history_chat_widget.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/input_message_widget.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.inputMessageFocusNode.unfocus();
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        
        // Side menu
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Image.asset(
                      R.ASSETS_ICON_IC_APP_PNG,
                      width: 24,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Jarvis",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Expanded(
                child: HistoryChatWidget(),
              ),
            ],
          ),
        ),
    
        body: const Column(
          children: [

            SizedBox(height: 32),
            
            // Header
            HeaderChatWidget(),
    
            // Body
            EmptyBodyMessageWidget(),
    
            // Input message
            InputMessageWidget(),
          ],
        ),
      ),
    );
  }
}



