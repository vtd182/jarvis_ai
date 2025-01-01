import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class ConnectUnitButton extends GetWidget<KlDetailViewModel> {
  const ConnectUnitButton({super.key, required this.onConnect});

  final Function onConnect;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                color: AppTheme.primaryBlue,
              ),
            ),
            child: Text(
              "Cancel",
              style: AppTheme.black_14w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: controller.isLoading.value
              ? null
              : () {
                  onConnect();
                },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: AppTheme.primaryLinearGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white))
                  : Text(
                      "Connect",
                      style: AppTheme.white_14w600,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
