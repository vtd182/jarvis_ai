import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_view_model.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class PromptTabBarItem extends GetWidget<PromptViewModel> {
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
        onTap: () {
          controller.indexTabPromt.value = index;
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: controller.indexTabPromt.value == index ? AppTheme.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: controller.indexTabPromt.value == index ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
