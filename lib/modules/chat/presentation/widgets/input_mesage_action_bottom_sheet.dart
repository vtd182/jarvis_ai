import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/promt_library_bottomsheet.dart';

class InputMesageActionBottomSheet extends GetWidget<ChatController> {
  const InputMesageActionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 24),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              controller.onUploadImage();
            },
            child: Row(
              children: [
                const Icon(
                  Icons.image_outlined,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  "Upload image",
                  style: AppStyle.boldStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              controller.onTakePhoto();
            },
            child: Row(
              children: [
                const Icon(Icons.camera_alt_outlined, size: 20),
                const SizedBox(width: 4),
                Text(
                  "Take photo",
                  style: AppStyle.boldStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Get.bottomSheet(const PromtLibraryBottomsheet());
            },
            child: Row(
              children: [
                Image.asset(
                  R.ASSETS_ICON_IC_PROMPT_PNG,
                  width: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  "Prompt",
                  style: AppStyle.boldStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
