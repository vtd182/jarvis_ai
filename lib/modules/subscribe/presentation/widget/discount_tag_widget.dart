import 'package:flutter/material.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';

class DiscountTagWidget extends StatelessWidget {
  final String id;
  const DiscountTagWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF512F),
            Color(0xFFDD2476),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "-${getDiscount(id)}%",
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.end,
        style: AppStyle.regularStyle().copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

int getDiscount(String id) {
  if (id.contains("weekly")) {
    return 30;
  } else if (id.contains("monthly")) {
    return 30;
  } else {
    return 30;
  }
}
