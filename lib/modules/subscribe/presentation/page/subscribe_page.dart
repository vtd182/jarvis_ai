import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/core/routes/app_route.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/subscribe/presentation/controller/subscribe_controller.dart';
import 'package:jarvis_ai/modules/subscribe/presentation/widget/subcribe_item.dart';

class SubscribePage extends StatefulWidget {
  const SubscribePage({
    super.key,
    this.canBack = true,
  });

  final bool canBack;

  @override
  State<StatefulWidget> createState() => SubscribeState();
}

class SubscribeState extends State<SubscribePage> {
  final controller = Get.find<SubscribeController>();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.init();
    });
    controller.onSubScreen.value = true;
    super.initState();
  }

  @override
  void dispose() {
    controller.canDismiss.value = false;
    controller.onSubScreen.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      widget.canBack ? Get.back() : Get.offAllNamed(AppRoute.chatRoute);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.blueBold),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF014946),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Jarvis Premium",
                    textAlign: TextAlign.center,
                    style: AppStyle.boldStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              R.ASSETS_ICON_IC_APP_PNG,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Unlimited tokens",
                              style: AppStyle.regularStyle(),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Image.asset(
                              R.ASSETS_ICON_IC_APP_PNG,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Remove ads",
                              style: AppStyle.regularStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Obx(
                  () => ListView.separated(
                    itemCount: controller.productDetailResponse.value.productDetails.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Obx(
                        () => SubscribeItem(
                          id: controller.productDetailResponse.value.productDetails[index].id,
                          currencySymbol: getCurrencySymbol(controller.productDetailResponse.value.productDetails[index].currencySymbol),
                          isHighLight: controller.productDetailResponse.value.productDetails[index].id == controller.monthSubscriptionId,
                          isChoosing: controller.currentItem.value == index,
                          title: controller.productDetailResponse.value.productDetails[index].title,
                          price: controller.productDetailResponse.value.productDetails[index].rawPrice.toStringAsFixed(0),
                          onTap: () => controller.onItemtap(index),
                          description: index == 1 ? "Most popular" : controller.productDetailResponse.value.productDetails[index].description,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                  ),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF06BEB6),
                          Color(0xff48B1BF),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "CONTINUE",
                      style: AppStyle.boldStyle(fontSize: 16).copyWith(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getCurrencySymbol(String price) {
  final currencySymbol = RegExp(r'^[^\d ]|[^\d ]$').firstMatch(price)?.group(0);
  return currencySymbol ?? "";
}
