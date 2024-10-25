import 'package:get/get.dart';
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page.dart';
import 'package:jarvis_ai/modules/bots/presentation/page/bot_page.dart';
import 'package:jarvis_ai/modules/chat/presentation/page/chat_page.dart';
import 'package:jarvis_ai/modules/subscribe/presentation/page/subscribe_page.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/page/knowledge_base_page.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/page/unit_page.dart';

class AppRoute {
  static const chatRoute = '/chat';
  static const botsRoute = '/bots';
  static const loginRoute = '/login';
  static const registerRoute = '/register';
  static const subscribeRoute = '/subscribe';
  static const knowledgeRoute = '/knowledge';
  static const knowledgeDetailRoute = '/knowledgeDetail';

  static final listPages = [
    GetPage(name: loginRoute, page: () => const LoginPage()),
    GetPage(name: chatRoute, page: () => ChatPage()),
    GetPage(name: botsRoute, page: () => BotPage()),
    GetPage(name: subscribeRoute, page: () => const SubscribePage()),
    GetPage(name: chatRoute, page: () => ChatPage()),
    GetPage(name: botsRoute, page: () => BotPage()),
    GetPage(name: knowledgeRoute, page: () => KnowledgeBasePage()),
    GetPage(name: knowledgeDetailRoute, page: () => UnitPage()),
  ];
}
