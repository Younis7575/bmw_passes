import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Validation for Email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    }

    // Allowed domains
    final allowedDomains = [
      "gmail.com",
      "yahoo.com",
      "outlook.com",
      "hotmail.com",
    ];

    if (!value.contains("@")) {
      return "Enter a valid email with @";
    }

    final domain = value.split("@").last;
    if (!allowedDomains.contains(domain)) {
      return "Only Gmail, Yahoo, Outlook, and Hotmail are allowed";
    }

    return null; // ✅ Valid
  }

  // Validation for Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    return null;
  }

  // Login Function
  void login() {
    if (formKey.currentState!.validate()) {
      // If validation passes
      Get.snackbar(
        "Success",
        "Login Successful",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to QR screen
      // You can replace this with API call
    } else {
      Get.snackbar(
        "Error",
        "Please fix errors",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
