import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';
import 'package:jarvis_ai/modules/chat/presentation/widgets/hint_question_widget.dart';

class EmptyBodyMessageWidget extends GetWidget<ChatController> {
  const EmptyBodyMessageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Image.asset(
              R.ASSETS_ICON_IC_HELLO_PNG,
              width: 30,
              height: 30,
            ),
            const SizedBox(height: 4),
            Text(
              "Hi, good afternoon!",
              style: AppStyle.boldStyle(fontSize: 26),
            ),
            const SizedBox(height: 4),
            const Text(
                "I’m Jarvis, your personal assistant.\nHere are some of my amazing powers"),
            const SizedBox(height: 8),

            // Upload Image
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){
                  controller.onUploadImage();
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          R.ASSETS_ICON_IC_UPLOAD_IMG_PNG,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Upload Image",
                        style: AppStyle.boldStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Hint questions
            const SizedBox(height: 8),
            Text(
              "You can ask me like this",
              style: AppStyle.boldStyle(color: AppColor.greyText, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const HintQuestionWidget(
              title: "Write an email",
              subTitle: "to submission project",
            ),
            const SizedBox(height: 4),
            const HintQuestionWidget(
              title: "Suggest events",
              subTitle: "for this summer",
            ),
            const SizedBox(height: 4),
            const HintQuestionWidget(
              title: "List some books",
              subTitle: "related to adventure",
            ),
            const SizedBox(height: 4),
            const HintQuestionWidget(
              title: "Explain an issue",
              subTitle: "why the earth is round",
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
