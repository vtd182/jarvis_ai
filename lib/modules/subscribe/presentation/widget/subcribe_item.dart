import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/subscribe/presentation/widget/discount_tag_widget.dart';

class SubscribeItem extends StatelessWidget {
  final String title;
  final String id;
  final String price;
  final VoidCallback onTap;
  final bool isChoosing;
  final bool isHighLight;
  final String currencySymbol;
  final String? description;
  const SubscribeItem({
    super.key,
    required this.title,
    required this.price,
    required this.onTap,
    required this.isChoosing,
    required this.isHighLight,
    required this.currencySymbol,
    required this.id,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: isChoosing ? 22 : 20,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: isChoosing ? const Color(0xFFDFFFF1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isChoosing ? const Color(0xFF48B1BF) : const Color(0xFF45556E),
                  width: isChoosing ? 2 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    !isChoosing ? R.ASSETS_ICON_IC_UN_CHECK_PNG : R.ASSETS_ICON_IC_CHECKED_PNG,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        validateName(title).tr,
                        style: AppStyle.boldStyle(fontSize: 18),
                      ),
                      if (description != null && description!.isNotEmpty)
                        Text(
                          description!.tr,
                          style: AppStyle.regularStyle(),
                        ),
                    ],
                  ),
                  const SizedBox(width: 9),
                  if (isHighLight)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF512F),
                              Color(0xFFDD2476),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        "BEST CHOICE",
                        style: AppStyle.regularStyle().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "$currencySymbol${countRawData(title, price).toStringAsFixed(0)}",
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.regularStyle().copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: const Color(0xFF45556E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: isHighLight
                                    ? const [
                                        Color(0xFFFF512F),
                                        Color(0xFFDD2476),
                                      ]
                                    : const [
                                        Color(0xFF06BEB6),
                                        Color(0xff48B1BF),
                                      ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds);
                            },
                            child: Text("$currencySymbol${price.tr}",
                                overflow: TextOverflow.ellipsis, style: AppStyle.boldStyle().copyWith(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Transform.translate(offset: const Offset(0, -10), child: DiscountTagWidget(id: id)),
            ),
          ],
        ),
      ),
    );
  }

  double countRawData(String title, String price) {
    final discount = getDiscount(title);
    final nprice = double.parse(price);
    return (nprice / (100 - discount)) * 100;
  }

  String validateName(String name) {
    return name.split(" ")[0];
  }
}
