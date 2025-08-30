import 'package:bmw_passes/constants/Text_Field_Widget.dart';
import 'package:bmw_passes/constants/custom_button.dart';
import 'package:bmw_passes/constants/custom_color.dart';
import 'package:bmw_passes/constants/custom_style.dart';
import 'package:bmw_passes/screens/home/qe_code_scanning_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: CustomColor.screenBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/login-icon.png",
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 15),
                  Text("Login", style: CustomStyle.loginText),
                  const SizedBox(height: 15),
                  Text(
                    "Lorem Ipsum is simply dummy text of the \nprinting and typesetting industry",
                    textAlign: TextAlign.center,
                    style: CustomStyle.contentText,
                  ),
                  const SizedBox(height: 25),

                  // ✅ Custom Text Fields
                  Column(
                    children: [
                      CustomTextField(
                        hintText: "Email",
                        controller: controller.emailController,
                        validator: controller.validateEmail,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: "Password",
                        isPassword: true,
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),
                  CustomButton(
                    text: "Sign in",
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.login();
                        Get.to(() => const QrScanScreen());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
