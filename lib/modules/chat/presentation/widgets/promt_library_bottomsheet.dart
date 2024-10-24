import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/create_private_prompt_dialog.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/private_prompt_tab_view_item.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/prompt_tab_bar_item.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/public_prompt_tab_view_item.dart';

class PromtLibraryBottomsheet extends GetWidget<ChatController> {
  const PromtLibraryBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Prompt Library",
                  style: AppStyle.boldStyle(fontSize: 18),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.dialog(const CreatePrivatePromptDialog());
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: AppColor.primaryLinearGradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColor.greyBackground,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PromptTabBarItem(
                  index: 0,
                  title: "My Prompt",
                ),
                PromptTabBarItem(
                  index: 1,
                  title: "Public Prompt",
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => controller.indexTabPromt.value == 0
                ? const PrivatePromptTabViewItem()
                : const PublicPromptTabViewItem(),
          )
        ],
      ),
    );
  }
}
