import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/usecase/get_ai_assistant_by_id_usecase.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class KBAIAssistantChatPageViewModel extends AppViewModel {
  final GetAIAssistantByIdUseCase _getAIAssistantByIdUseCase;
  KBAIAssistantChatPageViewModel(this._getAIAssistantByIdUseCase);
  String assistantId = "";

  final _assistant = Rxn<KBAIAssistant>();
  KBAIAssistant? get assistant => _assistant.value;

  Future<void> getAssistantById(String assistantId) async {
    final assistant = await _getAIAssistantByIdUseCase.run(assistantId: assistantId);
    _assistant.value = assistant;
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<Unit> _init() async {
    await getAssistantById(assistantId);
    return unit;
  }
}
