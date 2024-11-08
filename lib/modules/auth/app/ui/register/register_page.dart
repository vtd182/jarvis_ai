import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../shared/theme/app_theme.dart';
import '../login/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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

class _RegisterPageViewState extends State<RegisterPageView> {
  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final usernameFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final confirmPasswordFormKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;

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
    return Form(
      key: usernameFormKey,
      autovalidateMode: _autoValidateMode,
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
                final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                if (!emailValid) {
                  return "Please enter a valid email";
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
    );
  }

  Widget _buildFormRegister() {
    return Form(
      key: emailFormKey,
      autovalidateMode: _autoValidateMode,
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
                final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
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
    );
  }

  Widget _buildFormPassword() {
    return Form(
      key: passwordFormKey,
      autovalidateMode: _autoValidateMode,
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
    );
  }

  Widget _buildFormConfirmPassword() {
    return Form(
      key: confirmPasswordFormKey,
      autovalidateMode: _autoValidateMode,
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
    );
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
    if (_autoValidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
    final email = _emailTextController.text;
    final password = _passwordTextController.text;

    final isEmailValid = usernameFormKey.currentState?.validate() ?? false;
    final isPasswordValid = passwordFormKey.currentState?.validate() ?? false;
    final isConfirmPasswordValid = confirmPasswordFormKey.currentState?.validate() ?? false;
    final isValid = isEmailValid && isPasswordValid && isConfirmPasswordValid;

    if (!isValid) {
      return;
    } else {}
  }
}
