import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/domain/usecase/knowledge_base_sign_in_usecase.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../storage/spref.dart';

@injectable
class KBAIAssistantListPageViewModel extends AppViewModel {
  final KnowledgeBaseSignInUseCase _knowledgeBaseSignInUseCase;
  KBAIAssistantListPageViewModel(this._knowledgeBaseSignInUseCase);

  Future<Unit> onSignInKB() async {
    final token = await SPref.instance.getKBAccessToken();
    if (token != "") {
      final appToken = await SPref.instance.getAccessToken();
      if (appToken != "") {
        await run(
          () async {
            await _knowledgeBaseSignInUseCase.run(token: appToken!);
          },
        );
      }
    }
    return unit;
  }
}
