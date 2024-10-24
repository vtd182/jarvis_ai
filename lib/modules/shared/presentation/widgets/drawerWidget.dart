import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/shared/presentation/controller/drawer_controller.dart';
import 'package:jarvis_ai/modules/shared/presentation/widgets/history_chat_widget.dart';

class FunctionButtonsWidget extends GetView<AppDrawerController> {
  const FunctionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButton("Chat", () {
          Get.toNamed("/chat");
        }),
        _buildButton("Bot", () {
          Get.toNamed("/bots");
        }),
        _buildButton("Settings", () {
          Get.toNamed("/settings");
        }),
      ],
    );
  }

  Widget _buildButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        onTap();
        controller.indexFunctionSelected.value = title;
        controller.closeDrawer(); // Close drawer after button tap
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: controller.indexFunctionSelected.value == title ? AppColor.blueBold.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          const FunctionButtonsWidget(),
          const Divider(),
          const Expanded(
            child: HistoryChatWidget(),
          ),
        ],
      ),
    );
  }
}
