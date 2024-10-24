import 'package:flutter/material.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/app.dart';

class HintQuestionWidget extends StatelessWidget {
  const HintQuestionWidget({super.key, required this.title, required this.subTitle});
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColor.greyBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyle.boldStyle(fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            subTitle,
            style: AppStyle.regularStyle(color: AppColor.greyText),
          ),
        ],
      ),
    );
  }
}
