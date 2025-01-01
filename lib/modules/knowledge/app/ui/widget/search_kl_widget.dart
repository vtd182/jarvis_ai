import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/ads/event_log.dart';
import 'package:jarvis_ai/extensions/context_ext.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/knowledge_view_model.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/create_kl_dialog.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class SearchKlWidget extends GetWidget<KnowledgeViewModel> {
  const SearchKlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppTheme.grey,
              filled: true,
              suffixIcon: IconButton(
                onPressed: () {
                  context.hideKeyboard();
                  controller.getAllKnowledge(
                    query: controller.searchController.text,
                  );
                },
                icon: const Icon(
                  Icons.search,
                  color: AppTheme.primaryBlue,
                  size: 22,
                ),
              ),
              hintText: "Search",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.greyText,
                  fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            EventLog.logEvent("create_kl");
            Get.dialog(
              CreateKlDialog(),
              barrierDismissible: false,
              barrierColor: Colors.black.withOpacity(0.1),
            );
          },
          child: Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: AppTheme.primaryLinearGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.add,
              size: 22,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
