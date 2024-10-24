import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/modules/bots/presentation/widgets/bot_create_widget.dart';

class BotFloatingHoldMenu extends StatelessWidget {
  const BotFloatingHoldMenu({super.key});
  //menu for when holding on a bot widget to edit or delete

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            //Edit and delete buttons
            ListTile(
              title: const Text('Edit'),
              onTap: () {
                Get.bottomSheet(const BotsCreateWidget());
              },
            ),

            ListTile(
              title: const Text('Publish'),
              onTap: () {
                Get.back();
              },
            ),

            ListTile(
              title: const Text('Delete'),
              onTap: () {
                Get.back();
              },
            )
          ],
        ));
  }
}
