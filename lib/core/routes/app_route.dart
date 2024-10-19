import 'package:get/get.dart';
import 'package:jarvis_ai/modules/chat/presentation/page/chat_page.dart';

class AppRoute {
  static const chatRoute = '/chat';

  static final listPages = [
    GetPage(name: chatRoute, page: () =>  ChatPage()),
  ];
}
