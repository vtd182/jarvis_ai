import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/modules/shared/presentation/controller/drawer_controller.dart';

class HistoryChatWidget extends GetView<AppDrawerController> {
  const HistoryChatWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      itemBuilder: (_, index) {
        return InkWell(
          onTap: () {
            controller.indexHistorySelected.value = index;
            controller.indexFunctionSelected.value = "History";
            controller.closeDrawer();
          },
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: controller.indexHistorySelected.value == index &&
                      controller.indexFunctionSelected.value == "History"
                  ? AppColor.blueBold.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Text("History ${index + 1}"),
          ),
        );
      },
      itemCount: 8,
    );
  }
}
