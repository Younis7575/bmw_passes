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

// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// /// ✅ Request all required permissions
// Future<void> requestAllPermissions() async {
//   final statuses = await [
//     Permission.camera,
//     Permission.microphone,
//     Permission.location,
//     Permission.storage,
//     Permission.photos,
//     Permission.videos,
//     Permission.audio,
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
//       home: const LoginScreen(), // always opens login screen first
//     );
//   }
// }

//update code
import 'dart:async';
import 'package:bmw_passes/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ Request all required permissions
Future<void> requestAllPermissions() async {
  final statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.storage,
    Permission.photos,
    Permission.videos,
    Permission.audio,
  ].request();

  statuses.forEach((perm, status) {
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  });
}

/// ✅ SplashScreen to check login status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int _backgroundTimeout = 15 * 60; // 15 minutes in seconds

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    final lastActive = prefs.getInt("lastActive");

    if (token != null && lastActive != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = (now - lastActive) ~/ 1000; // seconds

      if (diff <= _backgroundTimeout) {
        // ✅ User still valid (within 15 min)
        Get.offAllNamed("/home");
        return;
      }
    }

    // ❌ Token not found or expired
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// ✅ Auto logout wrapper (for activity inside app)
class AutoLogoutWrapper extends StatefulWidget {
  final Widget child;
  const AutoLogoutWrapper({super.key, required this.child});

  @override
  State<AutoLogoutWrapper> createState() => _AutoLogoutWrapperState();
}

class _AutoLogoutWrapperState extends State<AutoLogoutWrapper> {
  Timer? _timer;
  final int _timeout = 25 * 60; // 25 minutes inactivity

  void _resetTimer() async {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: _timeout), _handleLogout);

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("lastActive", DateTime.now().millisecondsSinceEpoch);
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
    await prefs.remove("lastActive");
    Get.offAll(() => const LoginScreen());
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      onPanDown: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestAllPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMW Passes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
      getPages: [
        GetPage(
          name: "/home",
          page: () => AutoLogoutWrapper(child: const HomeScreen()),
        ),
      ],
    );
  }
}

/// Dummy HomeScreen (replace with your actual home/dashboard screen)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMW Passes Home")),
      body: Center(child: Text("Welcome back!")),
    );
  }
}
