import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/repositories/ai_chat_repository.dart';
import 'package:suga_core/suga_core.dart';

import '../enums/assistant.dart';
import '../models/ai_chat_response.dart';

@lazySingleton
class DoAIChatUseCase extends Usecase {
  final AIChatRepository _aiChatRepository;

  const DoAIChatUseCase(this._aiChatRepository);

  Future<AIChatResponse> run(Assistant assistant, String message) {
    return _aiChatRepository.doAIChat(assistant, message);
  }
}
