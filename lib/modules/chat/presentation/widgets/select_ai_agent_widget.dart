import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';

class SelectAiAgentWidget extends GetWidget<ChatController> {
  const SelectAiAgentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(13),
      ),
      offset: const Offset(0, 27),
      itemBuilder: (_) => <PopupMenuEntry<int>>[
        for (int i = 0; i < controller.listAiAgent.length; i++)
          PopupMenuItem<int>(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            height: 0,
            onTap: () {
              controller.indexAiAgent.value = i;
            },
            child: Row(
              children: [
                Image.asset(
                  controller.listAiAgent[i].imagePath,
                  width: 14,
                  height: 14,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    controller.listAiAgent[i].name,
                  ),
                ),
                Image.asset(R.ASSETS_ICON_IC_TOKEN_PNG, width: 14, height: 14),
                Text(
                  controller.listAiAgent[i].numberToken.toString(),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFD752),
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Obx(
          () => Text(
            "AI Agent: ${controller.listAiAgent[controller.indexAiAgent.value].name}",
          ),
        ),
      ),
    );
  }
}
