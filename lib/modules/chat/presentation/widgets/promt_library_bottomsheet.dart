import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';

class PromtLibraryBottomsheet extends StatelessWidget {
  const PromtLibraryBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text("Prompt Library"),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: AppColor.primaryLinearGradient),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              IconButton(
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),  
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close, size: 18,),
              ),
            ],
          )
        ],
      ),
    );
  }
}
