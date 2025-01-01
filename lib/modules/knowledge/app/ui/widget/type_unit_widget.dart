import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class TypeUnitWidget extends GetWidget<KlDetailViewModel> {
  const TypeUnitWidget(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.indexTypeUnit.value = index;
      },
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: controller.indexTypeUnit.value == index ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: controller.indexTypeUnit.value == index ? AppTheme.primaryBlue : AppTheme.greyText,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: controller.indexTypeUnit.value == index ? AppTheme.primaryBlue : Colors.transparent,
                  border: Border.all(
                    color: controller.indexTypeUnit.value == index ? AppTheme.primaryBlue : AppTheme.greyText,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.listTypeUnits[index].title,
                    style: AppTheme.black_14w600,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.listTypeUnits[index].description,
                    style: AppTheme.blackDarkOp50Percent_14w400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
