import 'package:bmw_passes/screens/auth/login_screen.dart';
import 'package:bmw_passes/screens/home/qe_code_scanning_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_controller.dart'; // import controller

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.forward();

    /// After splash, check login status
    Future.delayed(const Duration(seconds: 3), () async {
      final loginController = Get.put(LoginController());
      bool valid = await loginController.isSessionValid();

      if (valid) {
        /// ✅ Logged in & session not expired
        Get.offAll(() => const QrScanScreen());
      } else {
        /// ❌ No token or expired session
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
//is conteroller me splash screen k bad permisssion aye gii
// splash_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:bmw_passes/screens/auth/login_screen.dart';

// class SplashController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<double> fadeAnimation;
//   late Animation<double> scaleAnimation;

//   final Rx<PermissionStatus> cameraPermissionStatus =
//       PermissionStatus.denied.obs;
//   final RxBool isPermissionChecked = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
//       ),
//     );

//     scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
//       ),
//     );

//     animationController.forward();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     // Animation complete hone ka wait karein
//     await Future.delayed(const Duration(milliseconds: 2000));

//     // Camera permission check karein
//     await _checkCameraPermission();

//     // Next screen par navigate karein
//     _navigateToNextScreen();
//   }

//   Future<void> _checkCameraPermission() async {
//     try {
//       final status = await Permission.camera.status;
//       cameraPermissionStatus.value = status;

//       if (status.isDenied) {
//         // First time request karein
//         final result = await Permission.camera.request();
//         cameraPermissionStatus.value = result;
//       }

//       isPermissionChecked.value = true;
//     } catch (e) {
//       debugPrint("Permission error: $e");
//       isPermissionChecked.value = true;
//     }
//   }

//   void _navigateToNextScreen() {
//     Get.offAll(() => const LoginScreen());
//   }

//   // Optional: Agar aap user ko permission status dikhana chahte hain
//   String getPermissionStatusText() {
//     switch (cameraPermissionStatus.value) {
//       case PermissionStatus.granted:
//         return "Camera Access Granted";
//       case PermissionStatus.denied:
//         return "Camera Access Denied";
//       case PermissionStatus.restricted:
//         return "Camera Access Restricted";
//       case PermissionStatus.limited:
//         return "Camera Access Limited";
//       case PermissionStatus.permanentlyDenied:
//         return "Camera Access Permanently Denied";
//       default:
//         return "Unknown Status";
//     }
//   }

//   @override
//   void onClose() {
//     animationController.dispose();
//     super.onClose();
//   }
// }
