import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:suga_core/suga_core.dart';

import '../../../domain/usecases/sign_up_email_and_password_usecase.dart';

@lazySingleton
class RegisterPageViewModel extends AppViewModel {
  final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPasswordUseCase;
  RegisterPageViewModel(this._signUpWithEmailAndPasswordUseCase);
  Rx<AutovalidateMode> autoValidateMode = AutovalidateMode.disabled.obs;

  Future<Unit> register({required String username, required String email, required String password}) async {
    try {
      await showLoading();
      final success = await run(() => _signUpWithEmailAndPasswordUseCase.run(username: username, email: email, password: password));
      await hideLoading();
      if (success) {
        showToast("Success");
      } else {
        showToast("Failed");
      }
    } catch (e) {
      print("Error during register: $e");
    } finally {
      await hideLoading();
    }
    return unit;
  }
}
