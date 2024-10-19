import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/promt_library_bottomsheet.dart';

class InputMessageWidget extends GetWidget<ChatController> {
  const InputMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(const PromtLibraryBottomsheet());
            },
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: Colors.grey,
            iconSize: 18,
          ),
          Expanded(
            child: TextField(
              focusNode: controller.inputMessageFocusNode,
              decoration: const InputDecoration(
                hintText: "Chat anything with Jarvis...",
                hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
            color: Colors.grey,
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}
