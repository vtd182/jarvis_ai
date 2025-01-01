import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_view_model.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class ConfirmDeletePromptDialog extends GetWidget<PromptViewModel> {
  const ConfirmDeletePromptDialog(
      {super.key, required this.title, required this.onDelete});
  final String title;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure you want to delete this $title?",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Obx(
                  () => TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            onDelete();
                          },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: controller.isLoading.value
                            ? AppTheme.greyText
                            : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
