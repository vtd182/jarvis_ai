import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';

class CreatePrivatePromptDialog extends GetWidget<ChatController> {
  const CreatePrivatePromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Name",
              style: AppStyle.boldStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.greyBackground,
                filled: true,
                hintText: "Name of the prompt",
                hintStyle: AppStyle.regularStyle(color: AppColor.greyText),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              textAlignVertical: TextAlignVertical.top,
            ),
            const SizedBox(height: 8),
            Text(
              "Prompt",
              style: AppStyle.boldStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColor.primary,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Icon(
                        Icons.warning_amber_outlined,
                        color: AppColor.blueBold,
                        size: 16,
                      ),
                    ),
                    TextSpan(
                      text: " Use square brackets [] to specify user input.",
                      style: AppStyle.regularStyle(color: Colors.black).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.greyBackground,
                filled: true,
                hintMaxLines: 2,
                hintText: "e.g: Write an article [TOPIC], make sure to inclue these keywords: [KEYWORDS]",
                hintStyle: AppStyle.regularStyle(color: AppColor.greyText),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              textAlignVertical: TextAlignVertical.top,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColor.blueBold,
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppStyle.boldStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColor.primaryLinearGradient),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Save",
                      style: AppStyle.boldStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
