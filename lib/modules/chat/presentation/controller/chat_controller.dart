import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/chat/domain/models/ai_agent_model.dart';

class ChatController extends GetxController {
  final listAiAgent = [
    AiAgentModel(name: "GPT-3.5 Turbo", numberToken: 1, imagePath: R.ASSETS_ICON_IC_GPT_35_PNG),
    AiAgentModel(name: "GPT-4o", numberToken: 5, imagePath: R.ASSETS_ICON_IC_GPT_4_PNG),
    AiAgentModel(name: "GPT-4 Turbo", numberToken: 10, imagePath: R.ASSETS_ICON_IC_GPT_4_PNG),
    AiAgentModel(name: "Gemini 1.0 Pro", numberToken: 1, imagePath: R.ASSETS_ICON_IC_GEMINI_1_PNG),
    AiAgentModel(name: "Gemini 1.5 Pro", numberToken: 1, imagePath: R.ASSETS_ICON_IC_GEMINI_15_PNG),
    AiAgentModel(name: "Gemini 1.5 Flash", numberToken: 1, imagePath: R.ASSETS_ICON_IC_GEMINI_15_PNG),
  ];
  final indexAiAgent = 0.obs;
  final inputMessageFocusNode = FocusNode();
  final indexTabPromt = 0.obs;
  final inputMessageController = TextEditingController();
  final publicPromptController = TextEditingController();
  final privatePromptController = TextEditingController();

  final listCategoryPublicPrompt = [
    "All",
    "Other",
    "Writing",
    "Marketing",
    "Chatbot",
    "Seo",
    "Career",
    "Coding",
    "Productivity",
    "Education",
    "Business",
    "Fun",
  ];
  final indexCategoryPublicPrompt = 0.obs;
  @override
  void dispose() {
    inputMessageFocusNode.dispose();
    inputMessageController.dispose();
    publicPromptController.dispose();
    privatePromptController.dispose();
    super.dispose();
  }

  void onUploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  void onTakePhoto() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  }
}
