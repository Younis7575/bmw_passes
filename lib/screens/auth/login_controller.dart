import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_model.dart';
import '../home/qe_code_scanning_screen.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  // Username Validation
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username cannot be empty";
    }
    return null;
  }

  // Password Validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    return null;
  }

  // Login Function with API
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      var url = Uri.parse(
        "https://spmetesting.com/api/auth/login.php",
      ); // replace with actual login endpoint
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "X-APP-SECRET": "73706d652d6170706c69636174696f6e2d373836",
        },
        body: {
          "user_name": usernameController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      log("Login response=> ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Login Status=> ${response.statusCode}");
        var data = jsonDecode(response.body);
        var loginModel = LoginModel.fromJson(data);

        Get.snackbar(
          "Success",
          loginModel.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate to QR Screen
        Get.offAll(() => const QrScanScreen());
      } else {
        Get.snackbar(
          "Error",
          "Login failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
