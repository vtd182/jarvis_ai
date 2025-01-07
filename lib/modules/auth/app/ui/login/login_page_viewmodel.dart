import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/helpers/loading_helper.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page.dart';
import 'package:jarvis_ai/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../core/abstracts/app_view_model.dart';
import '../../../domain/usecases/sign_in_with_email_and_password_usecase.dart';

@injectable
class LoginPageViewModel extends AppViewModel {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;
  Rx<AutovalidateMode> autoValidateMode = AutovalidateMode.disabled.obs;

  LoginPageViewModel(this._signInWithEmailAndPasswordUseCase);

  Future<Unit> login(String email, String password) async {
    await showLoading();
    final success = await run(() => _signInWithEmailAndPasswordUseCase.run(email: email, password: password));
    await hideLoading();
    if (success) {
      await Get.offAll(() => const HomePage());
    }
    return unit;
  }

  Future<void> _showResultDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) async {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Ensure white background
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSuccess ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    await locator<LoadingHelper>().clear();
    await _showResultDialog(
      title: "Login error",
      message: "An unexpected error occurred during login: ${restError.getError()}.",
      isSuccess: false,
    );
    return unit;
  }
}
