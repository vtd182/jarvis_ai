import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsePromptViewModel extends GetxController {
  final listTextEditController = <TextEditingController>[].obs;

  final RegExp regExp = RegExp(r'\[(.*?)\]');

  final listMatches = <RegExpMatch>[].obs;

  final newMessage = ''.obs;

  final isViewPrompt = false.obs;

  void initializeTextControllers(String content) {
    listMatches.value = regExp.allMatches(content).toList();
    for (var match in listMatches) {
      listTextEditController.add(TextEditingController());
    }
  }

  void onTapSendButton() {
    for (int i = 0; i < listMatches.length; i++) {
      newMessage.value = newMessage.value.replaceFirst(listMatches[i].group(0)!, listTextEditController[i].text);
    }

    sendMessageToChat();
  }

  void sendMessageToChat() {
    print("Send message to chat: ${newMessage.value}");
    // TODO
  }
}
