import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/empty_body_message_widget.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/header_chat_widget.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/input_message_widget.dart';
import 'package:jarvis_ai/modules/shared/presentation/controller/drawer_controller.dart';
import 'package:jarvis_ai/modules/shared/presentation/widgets/drawerWidget.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final controller = Get.put(ChatController());
  final AppDrawerController drawerController = Get.put(AppDrawerController());

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              controller.inputMessageFocusNode.unfocus();
            },
            child: Scaffold(
              key: drawerController.scaffoldKey,

              // Side menu
              drawer: const AppDrawer(),

              body: const Column(
                children: [
                  // Header
                  HeaderChatWidget(),

                  // Body
                  EmptyBodyMessageWidget(),

                  // Input message
                  InputMessageWidget(),
                ],
              ),
            ),
          ),
        ));
  }
}
