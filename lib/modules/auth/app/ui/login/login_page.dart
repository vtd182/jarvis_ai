import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/ads/event_log.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page_viewmodel.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../gen/assets.gen.dart';
import '../forgot_password/forgot_password_page.dart';
import '../register/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  StatelessElement createElement() {
    EventLog.logEvent('login_page');
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
      body: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});
  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends BaseViewState<LoginPageView, LoginPageViewModel> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final usernameFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
          child: Column(
            children: [
              _buildLogo(),
              _buildTextTitle(),
              _buildDontHaveAccount(),
              const SizedBox(height: 30),
              _buildFormLogin(),
              const SizedBox(height: 30),
              _buildFormPassword(),
              _buildLoginButton(),
              _buildOrSplitDivider(),
              _buildLoginWithGoogleButton(),
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
        "Login to your \naccount",
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFormLogin() {
    return Obx(() => Form(
          key: usernameFormKey,
          autovalidateMode: viewModel.autoValidateMode.value,
          child: Column(
            children: [
              TextFormField(
                controller: _emailTextController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  final emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value);
                  if (!emailValid) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
              TextFormField(
                controller: _passwordTextController,
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildLoginButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Get.to(() => const ForgotPasswordPage());
          },
          child: const Text(
            "Forgot password?",
            style: TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 55,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _login();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppTheme.primaryBlue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
            "Or login with",
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

  Widget _buildLoginWithGoogleButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print('Login with Google');
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.grey.withOpacity(0.2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          shadowColor: Colors.transparent,
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

  Widget _buildDontHaveAccount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
          text: TextSpan(
        text: "Don't have account? ",
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: "Register",
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(
                  () => const RegisterPage(),
                );
              },
          ),
        ],
      )),
    );
  }

  Future<void> _login() async {
    if (viewModel.autoValidateMode.value == AutovalidateMode.disabled) {
      viewModel.autoValidateMode.value = AutovalidateMode.always;
    }
    final isEmailValid = usernameFormKey.currentState?.validate() ?? false;
    final isPasswordValid = passwordFormKey.currentState?.validate() ?? false;
    final isValid = isEmailValid && isPasswordValid;
    if (!isValid) {
      return;
    } else {
      final email = _emailTextController.text;
      final password = _passwordTextController.text;
      await viewModel.login(email, password);
      return;
    }
  }

  @override
  LoginPageViewModel createViewModel() {
    return locator<LoginPageViewModel>();
  }
}
