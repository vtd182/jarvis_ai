import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/bots/presentation/controller/bot_controller.dart';
import 'package:jarvis_ai/modules/bots/presentation/widgets/search_bot_widget.dart';
import 'package:jarvis_ai/modules/bots/presentation/widgets/bot_widget.dart';
import 'package:jarvis_ai/modules/bots/presentation/widgets/header_bot_widget.dart';
import 'package:jarvis_ai/modules/shared/presentation/controller/drawer_controller.dart';
import 'package:jarvis_ai/modules/shared/presentation/widgets/drawerWidget.dart';

class BotPage extends StatelessWidget {
  BotPage({super.key});
  final controller = Get.put(BotController());
  final AppDrawerController drawerController = Get.find();

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
                  HeaderBotWidget(),
                  // Search
                  SearchBotWidget(),

                  // Body
                  BotListWidget()
                ],
              ),
            ),
          ),
        ));
  }
}
