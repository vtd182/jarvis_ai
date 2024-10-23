import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';

class PrivatePromptTabViewItem extends GetWidget<ChatController> {
  const PrivatePromptTabViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller.privatePromptController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.greyBackground,
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
                size: 22,
              ),
              hintText: "Search",
              hintStyle:
                  AppStyle.boldStyle(color: AppColor.greyText, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "My Prompt ${index + 1}",
                          style: AppStyle.boldStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColor.greyText,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColor.greyText,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: 5),
          ),
        ],
      ),
    );
  }
}
