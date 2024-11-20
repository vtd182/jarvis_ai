import 'package:get/get.dart';

class AppBarController extends GetxController {
  var selectedModel = "GPT-3".obs;

  void updateModel(String model) {
    selectedModel.value = model;
  }
}
