import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/get_knowledge_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/domain/usecase/knowledge_base_sign_in_usecase.dart';
import 'package:jarvis_ai/storage/spref.dart';

class KnowledgeViewModel extends GetxController {
  final GetKnowledgeUsecase _getKnowledgeUsecase;

  KnowledgeViewModel(this._getKnowledgeUsecase);

  void getAllKnowledge() async {
    try {
      final token = await SPref.instance.getAccessToken();
      print ("tpoo token $token");
      await locator<KnowledgeBaseSignInUseCase>().run(token: (await SPref.instance.getAccessToken()) ?? "");
      print("tpoo press get");
      final res =
          await _getKnowledgeUsecase.run(queries: RequestKnowledgeModel());
      print("tpoo res $res");
    } catch (e) {
      print("error when get knowledge: $e");
    }
  }
}
