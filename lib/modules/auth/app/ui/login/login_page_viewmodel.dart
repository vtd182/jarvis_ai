import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../core/abstracts/app_view_model.dart';
import '../../../domain/usecases/sign_in_with_email_and_password_usecase.dart';

@injectable
class LoginPageViewModel extends AppViewModel {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;

  LoginPageViewModel(this._signInWithEmailAndPasswordUseCase);

  Future<Unit> login(String email, String password) async {
    try {
      await showLoading();
      final success = await run(() => _signInWithEmailAndPasswordUseCase.run(email: email, password: password));
      await hideLoading();
      if (success) {
        await Get.to(() => const HomePage());
      }
    } catch (e) {
      print("Error during login: $e");
    } finally {
      await hideLoading();
    }
    return unit;
  }
}
