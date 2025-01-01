import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/confirm_delete_prompt_dialog.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class UnitItem extends GetWidget<KlDetailViewModel> {
  const UnitItem({super.key, required this.item});

  final ResponseGetUnit item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            item.name,
            style: AppTheme.black_14w600,
          ),
        ),
        Expanded(
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            _convertSourceUnit(item.type.toString()),
            style: AppTheme.black_14w400,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 30,
            child: FittedBox(
              child: Switch(
                trackOutlineColor: const MaterialStatePropertyAll(Colors.transparent),
                inactiveTrackColor: AppTheme.greyText,
                value: item.status,
                onChanged: (val) {
                  controller.updateStatusUnit(id: item.id, status: val);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Get.dialog(ConfirmDeletePromptDialog(
                title: "unit",
                onDelete: () {
                  controller.deleteUnitById(id: item.id);
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
    );
  }

  String _convertSourceUnit(String source) {
    // replace all underscore with place and uppercase first letter of each word
    return source.replaceAll("_", " ").split(" ").map((e) => e[0].toUpperCase() + e.substring(1)).join(" ");
  }
}
