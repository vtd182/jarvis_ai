import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';

import '../controller/chat_controller.dart';

class PromptTabBarItem extends GetWidget<ChatController> {
  const PromptTabBarItem({
    super.key,
    required this.index,
    required this.title,
  });
  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: (){
          controller.indexTabPromt.value = index;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: controller.indexTabPromt.value == index
                ? AppColor.blueBold
                : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Text(
            title,
            style: AppStyle.boldStyle(
              fontSize: 14,
              color: controller.indexTabPromt.value == index
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}