import 'package:get/get.dart';
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page.dart';
import 'package:jarvis_ai/modules/bots/presentation/page/bot_page.dart';
import 'package:jarvis_ai/modules/chat/presentation/page/chat_page.dart';
import 'package:jarvis_ai/modules/subscribe/presentation/page/subscribe_page.dart';

class AppRoute {
  static const chatRoute = '/chat';
  static const botsRoute = '/bots';
  static const loginRoute = '/login';
  static const registerRoute = '/register';
  static const subscribeRoute = '/subscribe';

  static final listPages = [
    GetPage(name: loginRoute, page: () => const LoginPage()),
    GetPage(name: chatRoute, page: () => ChatPage()),
    GetPage(name: botsRoute, page: () => BotPage()),
    GetPage(name: subscribeRoute, page: () => const SubscribePage()),
  ];
}
