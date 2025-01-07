import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/core/helpers/loading_helper.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page.dart';
import 'package:jarvis_ai/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';

import '../../../domain/usecases/sign_up_email_and_password_usecase.dart';

@lazySingleton
class RegisterPageViewModel extends AppViewModel {
  final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPasswordUseCase;
  RegisterPageViewModel(this._signUpWithEmailAndPasswordUseCase);
  Rx<AutovalidateMode> autoValidateMode = AutovalidateMode.disabled.obs;

  Future<Unit> register({required String username, required String email, required String password}) async {
    await showLoading();
    final success = await run(() => _signUpWithEmailAndPasswordUseCase.run(
          username: username,
          email: email,
          password: password,
        ));
    await hideLoading();

    if (success) {
      await _showResultDialog(
        title: "Registration Successful",
        message: "Welcome $username! Your account has been successfully created.",
        isSuccess: true,
      );
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
                      if (isSuccess) {
                        // Navigate to Login screen if successful
                        Get.offAll(() => const LoginPage()); // Close the current screen
                      }
                    },
                    child: Text(
                      isSuccess ? "Login Now" : "OK",
                      style: TextStyle(
                        color: isSuccess ? Colors.blue : Colors.black, // Blue for "Login Now", black for "OK"
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
      title: "Error",
      message: "An unexpected error occurred during registration: ${restError.getError()}. Please try again.",
      isSuccess: false,
    );
    return unit;
  }
}
