import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../core/abstracts/app_view_model.dart';
import '../../../domain/usecases/sign_with_email_and_password_usecase.dart';

@injectable
class LoginPageViewModel extends AppViewModel {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;

  LoginPageViewModel(this._signInWithEmailAndPasswordUseCase);

  Future<Unit> login(String email, String password) async {
    await showLoading();
    final success = await run(() => _signInWithEmailAndPasswordUseCase.run(email: email, password: password));
    if (success) {
      showToast("Login success");
    }
    await hideLoading();
    return unit;
  }
}
