import 'package:bmw_passes/constants/custom_color.dart';
import 'package:bmw_passes/constants/custom_style.dart';
import 'package:bmw_passes/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: CustomColor.screenBackground,
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
                    style: CustomStyle.mainText,
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
// is code me splash screen phly show ho gi per permission mangy gi
// splash_screen.dart
// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:bmw_passes/constants/custom_style.dart';
// import 'package:bmw_passes/screens/splash/splash_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SplashController());

//     return Scaffold(
//       backgroundColor: CustomColor.screenBackground,
//       body: Center(
//         child: AnimatedBuilder(
//           animation: controller.animationController,
//           builder: (context, child) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Transform.scale(
//                   scale: controller.scaleAnimation.value,
//                   child: Opacity(
//                     opacity: controller.fadeAnimation.value,
//                     child: Image.asset(
//                       "assets/images/appicon.png",
//                       width: Get.width * 0.3,
//                       height: Get.width * 0.3,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Opacity(
//                   opacity: controller.fadeAnimation.value,
//                   child: Text("BMW M", style: CustomStyle.mainText),
//                 ),
//                 const SizedBox(height: 20),
//                 // Permission status display karein (optional)
//                 Obx(
//                   () => controller.isPermissionChecked.value
//                       ? Opacity(
//                           opacity: controller.fadeAnimation.value,
//                           child: Text(
//                             controller.getPermissionStatusText(),
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         )
//                       : const SizedBox.shrink(),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
