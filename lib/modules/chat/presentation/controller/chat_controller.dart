import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/chat/domain/models/ai_agent_model.dart';

class ChatController extends GetxController {
  final listAiAgent = [
    AiAgentModel(
        name: "GPT-3.5 Turbo",
        numberToken: 1,
        imagePath: R.ASSETS_ICON_IC_GPT_35_PNG),
    AiAgentModel(
        name: "GPT-4o", numberToken: 5, imagePath: R.ASSETS_ICON_IC_GPT_4_PNG),
    AiAgentModel(
        name: "GPT-4 Turbo",
        numberToken: 10,
        imagePath: R.ASSETS_ICON_IC_GPT_4_PNG),
    AiAgentModel(
        name: "Gemini 1.0 Pro",
        numberToken: 1,
        imagePath: R.ASSETS_ICON_IC_GEMINI_1_PNG),
    AiAgentModel(
        name: "Gemini 1.5 Pro",
        numberToken: 1,
        imagePath: R.ASSETS_ICON_IC_GEMINI_15_PNG),
    AiAgentModel(
        name: "Gemini 1.5 Flash",
        numberToken: 1,
        imagePath: R.ASSETS_ICON_IC_GEMINI_15_PNG),
  ];
  final indexAiAgent = 0.obs;
  final inputMessageFocusNode = FocusNode();

  @override
  void dispose() {
    inputMessageFocusNode.dispose();
    super.dispose();
  }
}
