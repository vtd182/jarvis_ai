import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/auth/domain/usecases/sign_out_usecase.dart';

@injectable
class SettingPageViewModel extends AppViewModel {
  final SignOutUseCase _signOutUseCase;

  SettingPageViewModel(this._signOutUseCase);

  Future<void> signOut() async {
    await showLoading();
    await _signOutUseCase.run();
    await hideLoading();
  }
}
