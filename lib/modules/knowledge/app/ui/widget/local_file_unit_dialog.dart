import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/connect_unit_button.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class LocalFileUnitDialog extends GetWidget<KlDetailViewModel> {
  const LocalFileUnitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Local File',
              style: AppTheme.black_16bold,
            ),
            const SizedBox(height: 8),
            const Divider(color: AppTheme.greyText),
            const SizedBox(height: 8),
            Text(
              'Upload local file',
              style: AppTheme.black_14w600,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                controller.onSelectLocalFile();
              },
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryBlue,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.upload_file,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Choose file to upload",
                      style: AppTheme.black_14w400,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => controller.localFile.value != null
                  ? Row(
                      children: [
                        const Icon(
                          Icons.file_upload,
                          color: AppTheme.greyText,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.localFile.value!.path.split('/').last,
                            style: AppTheme.black_14w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            ConnectUnitButton(
              onConnect: () {
                controller.onUploadLocalFile();
              },
            ),
          ],
        ),
      ),
    );
  }
}
