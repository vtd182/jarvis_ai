import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/ads/event_log.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:jarvis_ai/modules/auth/app/ui/register/register_page_viewmodel.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../locator.dart';
import '../../../../shared/theme/app_theme.dart';
import '../login/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  StatelessElement createElement() {
    EventLog.logEvent('register_page');
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: const RegisterPageView(),
    );
  }
}

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState
    extends BaseViewState<RegisterPageView, RegisterPageViewModel> {
  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final usernameFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final confirmPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            children: [
              _buildLogo(),
              _buildTextTitle(),
              _buildFormUsername(),
              const SizedBox(height: 30),
              _buildFormRegister(),
              const SizedBox(height: 30),
              _buildFormPassword(),
              const SizedBox(height: 30),
              _buildFormConfirmPassword(),
              _buildRegisterButton(),
              _buildOrSplitDivider(),
              _buildRegisterWithGoogleButton(),
              const SizedBox(height: 20),
              _buildHaveAnAccount(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Assets.icons.icJarvisLoginPage.image(),
    );
  }

  Widget _buildTextTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFormUsername() {
    return Obx(() => Form(
          key: usernameFormKey,
          autovalidateMode: viewModel.autoValidateMode.value,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: _usernameTextController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildFormRegister() {
    return Obx(() => Form(
          key: emailFormKey,
          autovalidateMode: viewModel.autoValidateMode.value,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: _emailTextController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    final emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildFormPassword() {
    return Obx(() => Form(
          key: passwordFormKey,
          autovalidateMode: viewModel.autoValidateMode.value,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: _passwordTextController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must have at least one uppercase letter";
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return "Password must have at least one lowercase letter";
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return "Password must have at least one number";
                    }
                    return null;
                  },
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildFormConfirmPassword() {
    return Obx(() => Form(
          key: confirmPasswordFormKey,
          autovalidateMode: viewModel.autoValidateMode.value,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: _confirmPasswordTextController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must have at least one uppercase letter";
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return "Password must have at least one lowercase letter";
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return "Password must have at least one number";
                    }
                    if (value != _passwordTextController.text) {
                      return "Password don't match";
                    }
                    return null;
                  },
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Confirm your password",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildRegisterButton() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _register();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
        ),
        child: const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOrSplitDivider() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              color: Colors.black.withOpacity(0.5),
              height: 1,
            ),
          ),
          Text(
            "Or register with",
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              color: Colors.black.withOpacity(0.5),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterWithGoogleButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print('Register with Google');
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.grey.withOpacity(0.2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icGoogle.image(width: 24, height: 24),
            const SizedBox(width: 10),
            const Text(
              "Google",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHaveAnAccount() {
    return RichText(
        text: TextSpan(
      text: "Already have an account? ",
      style: TextStyle(
        color: Colors.black.withOpacity(0.5),
        fontSize: 16,
      ),
      children: [
        TextSpan(
          text: "Login",
          style: const TextStyle(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Get.to(
                () => const LoginPage(),
              );
            },
        ),
      ],
    ));
  }

  void _register() {
    if (viewModel.autoValidateMode.value == AutovalidateMode.disabled) {
      viewModel.autoValidateMode.value = AutovalidateMode.always;
    }

    final email = _emailTextController.text;
    final password = _passwordTextController.text;
    final username = _usernameTextController.text;

    final isEmailValid = usernameFormKey.currentState?.validate() ?? false;
    final isPasswordValid = passwordFormKey.currentState?.validate() ?? false;
    final isConfirmPasswordValid =
        confirmPasswordFormKey.currentState?.validate() ?? false;
    final isValid = isEmailValid && isPasswordValid && isConfirmPasswordValid;

    if (!isValid) {
      showToast("Please fill in all the fields");
      return;
    } else {
      viewModel.register(username: username, email: email, password: password);
    }
  }

  @override
  RegisterPageViewModel createViewModel() {
    return locator<RegisterPageViewModel>();
  }
}
