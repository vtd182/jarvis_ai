import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/modules/bots/presentation/widgets/bot_create_widget.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/widget/knowledge_create_widget.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/widget/unit_create_widget.dart';
import 'package:jarvis_ai/modules/shared/presentation/controller/drawer_controller.dart';

class HeaderUnitWidget extends GetView<AppDrawerController> {
  const HeaderUnitWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            controller.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColor.primary,
          ),
          child: Row(
            children: [
              const Text("30 "),
              Image.asset(
                R.ASSETS_ICON_IC_TOKEN_PNG,
                width: 14,
                height: 14,
              ),
            ],
          ),
        ),
        IconButton(
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          onPressed: () {
            Get.bottomSheet(const UnitCreateWidget());
          },
          icon: const Icon(Icons.add_circle_rounded, color: AppColor.blueBold,),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
