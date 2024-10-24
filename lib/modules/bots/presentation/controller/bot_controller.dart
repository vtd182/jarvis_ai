import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/shared/domain/models/ai_agent_model.dart';

class BotController extends GetxController {
  final List<AiAgentModel> bots = [
    AiAgentModel(
        name: 'Jarvis',
        imagePath: "assets/images/jarvis.png",
        description: 'Your personal assistant',
        numberToken: 0,
        prompt:
            "Your name is Jarvis and you are my personal assistant. You are here to help me with my daily tasks. You can help me with my schedule, reminders, and even give me weather updates. You am here to make your life easier."),
    AiAgentModel(
        name: 'Programmer',
        imagePath: "assets/images/programmer.png",
        description: 'Your personal coding assistant',
        numberToken: 1,
        prompt:
            "Your name is Programmer and you are my personal coding assistant. You are here to help me with my coding tasks. You can help me with my coding problems, give me coding solutions, and even give me coding examples. You am here to make your life easier."),
    AiAgentModel(
        name: 'Teacher',
        imagePath: "assets/images/teacher.png",
        description: 'Your personal teacher assistant',
        numberToken: 2,
        prompt:
            "Your name is Teacher and you are my personal teacher assistant. You are here to help me with my learning tasks. You can help me with my learning problems, give me learning solutions, and even give me learning examples. You am here to make your life easier."),
    AiAgentModel(
        name: 'Doctor',
        imagePath: "assets/images/doctor.png",
        description: 'Your personal doctor assistant',
        numberToken: 3,
        prompt:
            "Your name is Doctor and you are my personal doctor assistant. You are here to help me with my health tasks. You can help me with my health problems, give me health solutions, and even give me health examples. You am here to make your life easier."),
  ];

  final indexAiAgent = 0.obs;
  final inputMessageFocusNode = FocusNode();
  final indexHistorySelected = (-1).obs;

  @override
  void dispose() {
    inputMessageFocusNode.dispose();
    super.dispose();
  }
}
