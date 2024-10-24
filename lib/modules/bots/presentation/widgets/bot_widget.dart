import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/bots/presentation/controller/bot_controller.dart';
import 'package:jarvis_ai/modules/bots/presentation/widgets/bot_floating_hold_menu.dart';

class BotListWidget extends GetWidget<BotController> {
  const BotListWidget({
    super.key,
  });
//list of bots

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: controller.bots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final bot = controller.bots[index];

              return GestureDetector(
                  onTap: () {
                    Get.toNamed("/chat");
                  },
                  onLongPress: () {
                    //Show popup menu
                    Get.bottomSheet(const BotFloatingHoldMenu());
                  },
                  child: BotWidget(bot.name, bot.imagePath, bot.description));
            },
          ),
        ],
      ),
    );
  }
}

class BotWidget extends StatelessWidget {
  final String name;
  final String image;
  final String description;

  const BotWidget(this.name, this.image, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Image.asset(image),
            ),
            Text(name, style: AppStyle.boldStyle()),
            Text(description, style: AppStyle.regularStyle()),
          ],
        ),
      ),
    );
  }
}
