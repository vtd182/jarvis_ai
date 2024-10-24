import 'package:flutter/material.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        surfaceTintColor: Colors.black.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 80,
            vertical: 40,
          ),
          height: 200,
          width: 40,
          child: const CircularProgressIndicator(
            color: AppColor.primary,
          ),
        ),
      ),
    );
  }
}