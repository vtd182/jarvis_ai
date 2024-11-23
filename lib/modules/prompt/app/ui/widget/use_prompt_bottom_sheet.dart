import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/use_prompt_view_model.dart';
import 'package:jarvis_ai/modules/prompt/domain/model/prompt_item_model.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class UsePromptBottomSheet extends StatefulWidget {
  const UsePromptBottomSheet({
    super.key,
    required this.promptItem,
    required this.onMessageSent, // Thêm callback
  });

  final PromptItemModel promptItem;
  final Function(String message) onMessageSent; // Hàm callback

  @override
  State<UsePromptBottomSheet> createState() => _UsePromptBottomSheetState();
}

class _UsePromptBottomSheetState extends State<UsePromptBottomSheet> {
  final controller = Get.put(UsePromptViewModel());

  @override
  void initState() {
    controller.initializeTextControllers(widget.promptItem.content ?? "");
    controller.newMessage.value = widget.promptItem.content ?? "";
    super.initState();
  }

  List<Widget> _buildTextFields() {
    final matches = controller.regExp.allMatches(widget.promptItem.content ?? "");
    int index = 0;
    return matches.map((match) {
      final hintText = match.group(1);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          controller: controller.listTextEditController[index++],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    widget.promptItem.title!,
                    style: AppTheme.black_18w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "${widget.promptItem.category ?? "Other"} - ${widget.promptItem.userName ?? "Anonymous"}",
              style: AppTheme.blackDark_16w400,
            ),
            if (widget.promptItem.description != null && widget.promptItem.description!.isNotEmpty) const SizedBox(height: 4),
            if (widget.promptItem.description != null && widget.promptItem.description!.isNotEmpty)
              Text(
                widget.promptItem.description!,
                style: AppTheme.greyText_14w400,
              ),
            const SizedBox(height: 8),
            Obx(
              () => controller.isViewPrompt.value
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Prompt",
                              style: AppTheme.black_16w600,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                // callback to add to chat
                                controller.sendMessageToChat();
                              },
                              child: const Text(
                                "Add to chat input",
                                style: TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.grey,
                          ),
                          padding: const EdgeInsets.all(8),
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            child: Text(
                              widget.promptItem.content ?? "",
                              style: AppTheme.blackDark_14w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        controller.isViewPrompt.value = true;
                      },
                      child: const Text(
                        "View Prompt",
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            ..._buildTextFields(),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                controller.onTapSendButton();
                widget.onMessageSent(controller.newMessage.value.trim());
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppTheme.primaryLinearGradient,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("Send", style: AppTheme.white_16w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
