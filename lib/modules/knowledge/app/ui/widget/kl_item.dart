import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/knowledge_view_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/confirm_delete_prompt_dialog.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class KlItem extends GetWidget<KnowledgeViewModel> {
  const KlItem({super.key, required this.kl});
  final ResponseGetKl kl;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.onNavigateToKlDetail(kl);
      },
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  kl.knowledgeName,
                  style: AppTheme.black_14w600,
                ),
                Text(
                  kl.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              kl.numUnits.toString(),
              style: AppTheme.black_14w400,
            ),
          ),
          Expanded(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              _convertSize(kl.totalSize),
              style: AppTheme.black_14w400,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.dialog(ConfirmDeletePromptDialog(
                  title: "knowledge",
                  onDelete: () {
                    controller.deleteKnowledgeById(id: kl.id);
                  },
                ));
              },
              child: const Icon(
                Icons.delete_outline,
                color: AppTheme.blackLight,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _convertSize(double klSize) {
    if (klSize < 1024) {
      return "${klSize.toStringAsFixed(2)} B";
    } else if (klSize < 1024 * 1024) {
      return "${(klSize / 1024).toStringAsFixed(2)} KB";
    } else if (klSize < 1024 * 1024 * 1024) {
      return "${(klSize / 1024 / 1024).toStringAsFixed(2)} MB";
    } else {
      return "${(klSize / 1024 / 1024 / 1024).toStringAsFixed(2)} GB";
    }
  }
}
