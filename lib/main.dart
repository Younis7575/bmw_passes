// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:bmw_passes/screens/home/qe_code_scanning_screen.dart';
// import 'package:bmw_passes/screens/splash/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// /// ✅ Check if session is still valid
// Future<bool> isSessionValid() async {
//   final prefs = await SharedPreferences.getInstance();
//   final loginTime = prefs.getInt(
//     'loginTime',
//   ); // stored timestamp (milliseconds)

//   if (loginTime == null) return false;

//   final now = DateTime.now().millisecondsSinceEpoch;
//   // final diff = now - loginTime;

//   // 30 days in milliseconds
//   // const thirtyDays = 30 * 24 * 60 * 60 * 1000;

//   // if (diff >= thirtyDays) {
//   //   // Session expired → clear storage
//   //   await prefs.clear();
//   //   return false;
//   // }
//   return true;
// }

// /// ✅ Request all required permissions
// Future<void> requestAllPermissions() async {
//   final statuses = await [
//     Permission.camera,
//     Permission.microphone,
//     Permission.location,
//     Permission.storage, // works until API 32
//     Permission.photos, // iOS only
//     Permission.videos, // iOS only
//     Permission.audio, // iOS only
//   ].request();

//   statuses.forEach((perm, status) {
//     if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   });
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Request all permissions at app startup
//   await requestAllPermissions();

//   // Check if user is logged in & session is valid
//   bool loggedIn = await isSessionValid();

//   runApp(MyApp(loggedIn: loggedIn));
// }

// class MyApp extends StatelessWidget {
//   final bool loggedIn;

//   const MyApp({super.key, required this.loggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'BMW Passes',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: SplashScreen(),
//     );
//   }
// }

// error check krny k liy ios
import 'dart:io';
import 'package:bmw_passes/screens/auth/login_screen.dart';
import 'package:bmw_passes/screens/home/qe_code_scanning_screen.dart';
import 'package:bmw_passes/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ Request camera permission safely
Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    debugPrint("✅ Camera permission granted");
  } else if (status.isDenied) {
    debugPrint("❌ Camera permission denied (user can allow again)");

    // iOS par "Don't Allow" ke liye dialog show karo
    if (Platform.isIOS) {
      Get.defaultDialog(
        title: "Permission Needed",
        middleText:
            "Camera access is required to scan QR codes. "
            "Please allow it from Settings if you denied it.",
        textConfirm: "OK",
        onConfirm: () => Get.back(),
      );
    }
  } else if (status.isPermanentlyDenied) {
    debugPrint("⚠️ Camera permission permanently denied");
    Get.defaultDialog(
      title: "Permission Required",
      middleText:
          "Camera access is needed to scan QR codes. Please enable it in Settings.",
      textConfirm: "Go to Settings",
      textCancel: "Cancel",
      onConfirm: () {
        openAppSettings();
      },
    );
  }
}

/// ✅ Check if session is still valid (5 minutes)
Future<bool> isSessionValid() async {
  final prefs = await SharedPreferences.getInstance();
  final loginTime = prefs.getString("login_time");
  final token = prefs.getString("access_token");

  if (token == null || loginTime == null) return false;

  final loginDate = DateTime.parse(loginTime);
  final now = DateTime.now();
  final diff = now.difference(loginDate).inMinutes;

  if (diff > 5) {
    await prefs.clear();
    return false;
  }
  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ App launch hote hi permission maango
  // await requestCameraPermission();

  // ✅ Check login session
  bool loggedIn = await isSessionValid();

  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMW Passes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: loggedIn ? const QrScanScreen() : const LoginScreen(),
      home: const SplashScreen(),
    );
  }
}

//is code me phly splash screen aie gi per login ho ga per permission mangi jay gi

// import 'dart:io';
// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:bmw_passes/screens/home/qe_code_scanning_screen.dart';
// import 'package:bmw_passes/screens/splash/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// /// ✅ Request camera permission safely
// Future<void> requestCameraPermission() async {
//   final status = await Permission.camera.request();

//   if (status.isGranted) {
//     debugPrint("✅ Camera permission granted");
//   } else if (status.isDenied) {
//     debugPrint("❌ Camera permission denied (user can allow again)");

//     if (Platform.isIOS) {
//       Get.defaultDialog(
//         title: "Permission Needed",
//         middleText:
//             "Camera access is required to scan QR codes. Please allow it from Settings if you denied it.",
//         textConfirm: "OK",
//         onConfirm: () => Get.back(),
//       );
//     }
//   } else if (status.isPermanentlyDenied) {
//     debugPrint("⚠️ Camera permission permanently denied");
//     Get.defaultDialog(
//       title: "Permission Required",
//       middleText:
//           "Camera access is needed to scan QR codes. Please enable it in Settings.",
//       textConfirm: "Go to Settings",
//       textCancel: "Cancel",
//       onConfirm: () {
//         openAppSettings();
//       },
//     );
//   }
// }

// /// ✅ Check if session is still valid (5 minutes)
// Future<bool> isSessionValid() async {
//   final prefs = await SharedPreferences.getInstance();
//   final loginTime = prefs.getString("login_time");
//   final token = prefs.getString("access_token");

//   if (token == null || loginTime == null) return false;

//   final loginDate = DateTime.parse(loginTime);
//   final now = DateTime.now();
//   final diff = now.difference(loginDate).inMinutes;

//   if (diff > 5) {
//     await prefs.clear();
//     return false;
//   }
//   return true;
// }

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'BMW Passes',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const SplashScreen(), // ✅ Ab splash screen pehle chalegi
//     );
//   }
// }
