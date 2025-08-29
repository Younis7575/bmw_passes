import 'package:bmw_passes/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: controller.scaleAnimation.value,
                  child: Opacity(
                    opacity: controller.fadeAnimation.value,
                    child: Image.asset(
                      "assets/images/appicon.png", // your app icon
                      width: Get.width * 0.3,
                      height: Get.width * 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: controller.fadeAnimation.value,
                  child: Text(
                    "BMW M", // your app name
                    style: TextStyle(
                      fontSize: Get.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

