import 'package:bmw_passes/constants/Text_Field_Widget.dart';
import 'package:bmw_passes/constants/custom_button.dart';
import 'package:bmw_passes/constants/custom_color.dart';
import 'package:bmw_passes/constants/custom_style.dart';
import 'package:bmw_passes/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.screenBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                children: const [
                  CustomTextField(hintText: "Email"),
                  SizedBox(height: 15),
                  CustomTextField(hintText: "Password", isPassword: true),
                ],
              ),
              SizedBox(height: 35),
              CustomButton(
                text: "Sign in",
                onPressed: () {
                  // Call your controller.login();
                  Get.to(() => const QrScanScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
