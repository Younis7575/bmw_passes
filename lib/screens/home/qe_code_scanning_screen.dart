// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:bmw_passes/constants/custom_button.dart';
// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:bmw_passes/screens/home/user_detail_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../constants/custom_style.dart';

// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});

//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }

// class _QrScanScreenState extends State<QrScanScreen>
//     with SingleTickerProviderStateMixin {
//   final MobileScannerController controller = MobileScannerController();
//   String? qrResult;
//   double zoomValue = 0.0;
//   bool isFetching = false;
//   bool showErrorOverlay = false;
//   String errorTitle = "";
//   String errorSubtitle = "";

//   /// ✅ Verify customer by QR result
//   /// ✅ Verify customer by QR result
//   Future<void> verifyCustomer(String customerId) async {
//     if (isFetching) return;
//     setState(() => isFetching = true);

//     log("📌 Scanned Customer ID => $customerId"); // ✅ Print customer_id

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("access_token"); // ✅ fixed key
//     log("Access Token => $token");

//     if (token == null || token.isEmpty) {
//       Get.snackbar("Error", "No access token found. Please login again.");
//       Get.offAll(() => const LoginScreen());
//       return;
//     }

//     var url = Uri.parse(
//       "https://spmetesting.com/api/auth/verify-scanned-customer.php",
//     );

//     var response = await http.post(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/x-www-form-urlencoded",
//         "X-API-ACCESS-TOKEN": token,
//         "X-APP-KEY": "73706d652d6170706c69636174696f6e2d373836",
//       },
//       body: {
//         "customer_id": customerId.trim(), // ✅ clean up QR string
//       },
//     );

//     log("Verify API Response => ${response.body}");
//     log("Verify API Token => $token");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       log("Verify API Status => ${response.statusCode}");
//       var data = jsonDecode(response.body);

//       if (data["status"] == "success") {
//         /// ✅ Navigate with verified user data
//         Get.to(() => UserDetailScreen(userData: data["data"]));
//       } else {
//         /// ❌ Show Alert Box if customer not found
//         _showErrorDialog(context, data["message"] ?? "Customer not found");
//       }
//     } else {
//       _showErrorDialog(context, "Verification failed. Try again.");
//     }
//     setState(() => isFetching = false);
//   }

//   /// ❌ Show error dialog when user not found
//   void _showErrorDialog(BuildContext context, String message) {
//     setState(() {
//       showErrorOverlay = true;
//       errorTitle = "Verification Failed";
//       errorSubtitle = message;
//     });

//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         setState(() => showErrorOverlay = false);
//       }
//     });
//   }

//   /// ✅ Logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Logout",
//                   style: CustomStyle.infoLabel.copyWith(
//                     color: CustomColor.dot,
//                     fontSize: 22,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Are you sure you want to logout?",
//                   textAlign: TextAlign.center,
//                   style: CustomStyle.infoValue.copyWith(
//                     color: CustomColor.contentText,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 25,
//                           vertical: 12,
//                         ),
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text(
//                         "Cancel",
//                         style: CustomStyle.infoValue.copyWith(
//                           color: CustomColor.contentText,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 12,
//                         ),
//                       ),
//                       onPressed: () async {
//                         Navigator.of(context).pop();

//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//                         await prefs.remove("access_token");

//                         Get.offAll(() => const LoginScreen());
//                       },
//                       child: const Text("OK", style: TextStyle(fontSize: 16)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   late AnimationController _animController;
//   late Animation<double> _positionAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // controller.start(); // 🔑 Ensure camera session starts

//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _positionAnimation = Tween<double>(
//       begin: -1,
//       end: 1,
//     ).animate(_animController);
//   }

//   @override
//   void dispose() {
//     controller.dispose(); // 🔑 Release camera properly
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       controller.stop();
//     }
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       controller.start();
//     }
//   }

//   // @override
//   // void reassemble() {
//   //   super.reassemble();
//   //   if (defaultTargetPlatform == TargetPlatform.android) {
//   //     controller.stop();
//   //   }
//   //   controller.start();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final double boxWidth = MediaQuery.of(context).size.width * 0.80;
//     final double boxHeight = MediaQuery.of(context).size.height * 0.35;
//     const double topOffset = 170;

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             /// 📷 Camera Scanner
//             MobileScanner(
//               controller: controller,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 for (final barcode in barcodes) {
//                   if (barcode.rawValue != null && !isFetching) {
//                     qrResult = barcode.rawValue;
//                     verifyCustomer(qrResult!); // ✅ call API
//                   }
//                 }
//               },
//             ),

//             /// 🌓 Overlay with transparent box
//             ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 CustomColor.screenBackground,
//                 BlendMode.srcOut,
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.black,
//                       backgroundBlendMode: BlendMode.dstOut,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: topOffset),
//                       child: Container(
//                         width: boxWidth,
//                         height: boxHeight,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// 🔵 Blue corners
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: Stack(
//                     children: [
//                       _buildCorner(Alignment.topLeft),
//                       _buildCorner(Alignment.topRight),
//                       _buildCorner(Alignment.bottomLeft),
//                       _buildCorner(Alignment.bottomRight),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔴 Animated Red Line
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: AnimatedBuilder(
//                     animation: _positionAnimation,
//                     builder: (context, child) {
//                       return Align(
//                         alignment: Alignment(0, _positionAnimation.value),
//                         child: Container(
//                           width: boxWidth,
//                           height: 3,
//                           color: Colors.red,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔙 Back & Logout
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // IconButton(
//                   //   icon: const Icon(
//                   //     Icons.arrow_back,
//                   //     color: CustomColor.mainText,
//                   //     size: 25,
//                   //   ),
//                   //   onPressed: () => Get.back(),
//                   // ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.logout_outlined,
//                       color: CustomColor.mainText,
//                       size: 25,
//                     ),
//                     onPressed: () => _showLogoutDialog(context),
//                   ),
//                 ],
//               ),
//             ),

//             /// 📏 Zoom + Scan Button
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// 📏 Zoom Slider
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.remove, color: CustomColor.slider),
//                           Expanded(
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 thumbShape: const ShadowSliderThumbShape(
//                                   thumbRadius: 6,
//                                 ),
//                               ),
//                               child: Slider(
//                                 value: zoomValue,
//                                 min: 0.0,
//                                 max: 1.0,
//                                 activeColor: Colors.red,
//                                 onChanged: (val) async {
//                                   setState(() => zoomValue = val);
//                                   await controller.setZoomScale(val);
//                                 },
//                               ),
//                             ),
//                           ),
//                           const Icon(Icons.add, color: CustomColor.slider),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     /// 🔘 Manual Scan Button
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: GestureDetector(
//                         onTap: () {
//                           if (qrResult != null && qrResult!.isNotEmpty) {
//                             verifyCustomer(qrResult!);
//                           } else {
//                             Get.snackbar("Error", "No QR code scanned yet!");
//                           }
//                         },
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             final screenWidth = MediaQuery.of(
//                               context,
//                             ).size.width;

//                             return SizedBox(
//                               width:
//                                   screenWidth * 0.9, // screen ka 90% width lega
//                               height: 60, // fixed but responsive height
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: CustomColor.mainText,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     left:
//                                         screenWidth *
//                                         0.35, // image center-ish rakho
//                                     top: -30,
//                                     child: Image.asset(
//                                       "assets/images/QR.1.png",
//                                       width:
//                                           screenWidth *
//                                           0.2, // responsive image size
//                                       height: screenWidth * 0.2,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),

//                     // Padding(
//                     //   padding: const EdgeInsets.all(20),
//                     //   child: SizedBox(
//                     //     width: 364,
//                     //     height: 67,
//                     //     child: GestureDetector(
//                     //       onTap: () {
//                     //         if (qrResult != null && qrResult!.isNotEmpty) {
//                     //           verifyCustomer(qrResult!);
//                     //         } else {
//                     //           Get.snackbar("Error", "No QR code scanned yet!");
//                     //         }
//                     //       },
//                     //       child: Stack(
//                     //         clipBehavior: Clip.none,
//                     //         children: [
//                     //           Container(
//                     //             decoration: BoxDecoration(
//                     //               color: CustomColor.mainText,
//                     //               borderRadius: BorderRadius.circular(12),
//                     //             ),
//                     //           ),
//                     //           Positioned(
//                     //             left: 130,
//                     //             top: -40,
//                     //             child: Image.asset(
//                     //               "assets/images/QR.1.png",
//                     //               width: 90,
//                     //               height: 90,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),

//             if (showErrorOverlay) ...[
//               /// Blur Background
//               Positioned.fill(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                   child: Container(color: Colors.black.withOpacity(0.3)),
//                 ),
//               ),

//               /// Styled Error Box
//               Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       /// 🔴 Red Circle Icon
//                       Image.asset(
//                         "assets/images/error_info.png",
//                         width: 60,
//                         height: 60,
//                       ),

//                       const SizedBox(height: 20),

//                       /// 📝 Error Message
//                       Text(
//                         "Oops! User not found",
//                         style: CustomStyle.mainText.copyWith(
//                           color: CustomColor.contentText,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),

//                       const SizedBox(height: 25),

//                       /// 🔘 Scan More Button
//                       Container(
//                         width: 200,
//                         child: CustomButton(
//                           text: "Scan More",
//                           onPressed: () {
//                             setState(() => showErrorOverlay = false);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔵 Build corner edges
//   Widget _buildCorner(Alignment alignment) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           border: Border(
//             top:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.topRight
//                 ? const BorderSide(color: Colors.blue, width: 15)
//                 : BorderSide.none,
//             left:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.bottomLeft
//                 ? const BorderSide(color: Colors.blue, width: 15)
//                 : BorderSide.none,
//             right:
//                 alignment == Alignment.topRight ||
//                     alignment == Alignment.bottomRight
//                 ? const BorderSide(color: Colors.blue, width: 15)
//                 : BorderSide.none,
//             bottom:
//                 alignment == Alignment.bottomLeft ||
//                     alignment == Alignment.bottomRight
//                 ? const BorderSide(color: Colors.blue, width: 15)
//                 : BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ✅ Custom slider thumb
// class ShadowSliderThumbShape extends SliderComponentShape {
//   final double thumbRadius;

//   const ShadowSliderThumbShape({this.thumbRadius = 8});

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(thumbRadius);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     final Canvas canvas = context.canvas;

//     final shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(0.3)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

//     canvas.drawCircle(center, thumbRadius + 2, shadowPaint);

//     final thumbPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.red;
//     canvas.drawCircle(center, thumbRadius, thumbPaint);
//   }
// }

//update code
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:bmw_passes/constants/custom_button.dart';
// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:bmw_passes/constants/custom_style.dart';
// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:bmw_passes/screens/home/user_detail_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});

//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }

// class _QrScanScreenState extends State<QrScanScreen>
//     with SingleTickerProviderStateMixin {
//   final MobileScannerController controller = MobileScannerController();
//   String? qrResult;
//   double zoomValue = 0.0;
//   bool isFetching = false;
//   bool showErrorOverlay = false;
//   String errorTitle = "";
//   String errorSubtitle = "";
//   bool showLoginButton = false;

//   /// ✅ Verify customer by QR result
//   Future<void> verifyCustomer(String customerId) async {
//     if (isFetching) return;
//     setState(() => isFetching = true);

//     log("📌 Scanned Customer ID => $customerId");

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("access_token");
//     log("Access Token => $token");

//     if (token == null || token.isEmpty) {
//       Get.snackbar("Error", "No access token found. Please login again.");
//       Get.offAll(() => const LoginScreen());
//       return;
//     }

//     var url = Uri.parse(
//       "https://spmetesting.com/api/auth/verify-scanned-customer.php",
//     );

//     var response = await http.post(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/x-www-form-urlencoded",
//         "X-API-ACCESS-TOKEN": token,
//         "X-APP-KEY": "73706d652d6170706c6c69636174696f6e2d373836",
//       },
//       body: {"customer_id": customerId.trim()},
//     );

//     log("Verify API Response => ${response.body}");
//     log("Verify API Status => ${response.statusCode}");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);

//       if (data["status"] == "success") {
//         Get.to(() => UserDetailScreen(userData: data["data"]));
//       } else {
//         _showErrorDialog(
//           title: "Verification Failed",
//           subtitle: data["message"] ?? "Invalid QR code",
//         );
//       }
//     } else if (response.statusCode == 401) {
//       // ✅ Token expired case
//       _showErrorDialog(
//         title: "Your token has expired",
//         subtitle: "Please login again to continue.",
//         showLoginButton: true,
//       );
//     } else {
//       _showErrorDialog(
//         title: "Error",
//         subtitle: "Something went wrong. Try again.",
//       );
//     }

//     setState(() => isFetching = false);
//   }

//   /// ❌ Show error dialog when user not found or token expired
//   void _showErrorDialog({
//     required String title,
//     required String subtitle,
//     bool showLoginButton = false,
//   }) {
//     setState(() {
//       showErrorOverlay = true;
//       errorTitle = title;
//       errorSubtitle = subtitle;
//       this.showLoginButton = showLoginButton;
//     });
//   }

//   /// ✅ Logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Logout",
//                   style: CustomStyle.infoLabel.copyWith(
//                     color: CustomColor.dot,
//                     fontSize: 22,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Are you sure you want to logout?",
//                   textAlign: TextAlign.center,
//                   style: CustomStyle.infoValue.copyWith(
//                     color: CustomColor.contentText,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text(
//                         "Cancel",
//                         style: CustomStyle.infoValue.copyWith(
//                           color: CustomColor.contentText,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//                         await prefs.remove("access_token");
//                         Get.offAll(() => const LoginScreen());
//                       },
//                       child: const Text("OK", style: TextStyle(fontSize: 16)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   late AnimationController _animController;
//   late Animation<double> _positionAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//     _positionAnimation = Tween<double>(
//       begin: -1,
//       end: 1,
//     ).animate(_animController);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       controller.stop();
//     }
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       controller.start();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double boxWidth = MediaQuery.of(context).size.width * 0.80;
//     final double boxHeight = MediaQuery.of(context).size.height * 0.35;
//     const double topOffset = 170;

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             /// 📷 Scanner
//             MobileScanner(
//               controller: controller,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 for (final barcode in barcodes) {
//                   if (barcode.rawValue != null && !isFetching) {
//                     qrResult = barcode.rawValue;
//                     verifyCustomer(qrResult!);
//                   }
//                 }
//               },
//             ),

//             /// 🔵 Overlay
//             ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 CustomColor.screenBackground,
//                 BlendMode.srcOut,
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.black,
//                       backgroundBlendMode: BlendMode.dstOut,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: topOffset),
//                       child: Container(
//                         width: boxWidth,
//                         height: boxHeight,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// 🔴 Animated line
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: AnimatedBuilder(
//                     animation: _positionAnimation,
//                     builder: (context, child) {
//                       return Align(
//                         alignment: Alignment(0, _positionAnimation.value),
//                         child: Container(
//                           width: boxWidth,
//                           height: 3,
//                           color: Colors.red,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔙 Logout
//             Positioned(
//               top: 10,
//               right: 10,
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.logout_outlined,
//                   color: CustomColor.mainText,
//                   size: 25,
//                 ),
//                 onPressed: () => _showLogoutDialog(context),
//               ),
//             ),

//             /// 📏 Zoom + Manual Scan Button
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// 📏 Zoom Slider
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.remove, color: CustomColor.slider),
//                           Expanded(
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 // thumbShape: const ShadowSliderThumbShape(
//                                 //   thumbRadius: 6,
//                                 // ),
//                               ),
//                               child: Slider(
//                                 value: zoomValue,
//                                 min: 0.0,
//                                 max: 1.0,
//                                 activeColor: Colors.red,
//                                 onChanged: (val) async {
//                                   setState(() => zoomValue = val);
//                                   await controller.setZoomScale(val);
//                                 },
//                               ),
//                             ),
//                           ),
//                           const Icon(Icons.add, color: CustomColor.slider),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     /// 🔘 Manual Scan Button
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: GestureDetector(
//                         onTap: () {
//                           if (qrResult != null && qrResult!.isNotEmpty) {
//                             verifyCustomer(qrResult!);
//                           } else {
//                             Get.snackbar("Error", "No QR code scanned yet!");
//                           }
//                         },
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             final screenWidth = MediaQuery.of(
//                               context,
//                             ).size.width;

//                             return SizedBox(
//                               width:
//                                   screenWidth * 0.9, // screen ka 90% width lega
//                               height: 60, // fixed but responsive height
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: CustomColor.mainText,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     left:
//                                         screenWidth *
//                                         0.35, // image center-ish rakho
//                                     top: -30,
//                                     child: Image.asset(
//                                       "assets/images/QR.1.png",
//                                       width:
//                                           screenWidth *
//                                           0.2, // responsive image size
//                                       height: screenWidth * 0.2,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),

//                     // Padding(
//                     //   padding: const EdgeInsets.all(20),
//                     //   child: SizedBox(
//                     //     width: 364,
//                     //     height: 67,
//                     //     child: GestureDetector(
//                     //       onTap: () {
//                     //         if (qrResult != null && qrResult!.isNotEmpty) {
//                     //           verifyCustomer(qrResult!);
//                     //         } else {
//                     //           Get.snackbar("Error", "No QR code scanned yet!");
//                     //         }
//                     //       },
//                     //       child: Stack(
//                     //         clipBehavior: Clip.none,
//                     //         children: [
//                     //           Container(
//                     //             decoration: BoxDecoration(
//                     //               color: CustomColor.mainText,
//                     //               borderRadius: BorderRadius.circular(12),
//                     //             ),
//                     //           ),
//                     //           Positioned(
//                     //             left: 130,
//                     //             top: -40,
//                     //             child: Image.asset(
//                     //               "assets/images/QR.1.png",
//                     //               width: 90,
//                     //               height: 90,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),

//             /// ⚠️ Error Overlay
//             if (showErrorOverlay) ...[
//               Positioned.fill(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                   child: Container(color: Colors.black.withOpacity(0.3)),
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         "assets/images/error_info.png",
//                         width: 60,
//                         height: 60,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         errorTitle,
//                         style: CustomStyle.mainText.copyWith(
//                           color: CustomColor.contentText,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         errorSubtitle,
//                         style: CustomStyle.infoValue.copyWith(
//                           color: CustomColor.contentText,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 25),
//                       if (showLoginButton)
//                         CustomButton(
//                           text: "Login Again",
//                           onPressed: () {
//                             Get.offAll(() => const LoginScreen());
//                           },
//                         )
//                       else
//                         CustomButton(
//                           text: "Scan More",
//                           onPressed: () {
//                             setState(() => showErrorOverlay = false);
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:bmw_passes/constants/custom_button.dart';
// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:bmw_passes/constants/custom_style.dart';
// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:bmw_passes/screens/home/user_detail_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});

//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }

// class _QrScanScreenState extends State<QrScanScreen>
//     with SingleTickerProviderStateMixin {
//   final MobileScannerController controller = MobileScannerController();
//   String? qrResult;
//   double zoomValue = 0.0;
//   bool isFetching = false;
//   bool showErrorOverlay = false;
//   String errorTitle = "";
//   String errorSubtitle = "";
//   bool showLoginButton = false;

//   /// ✅ Verify customer by QR result
//   Future<void> verifyCustomer(String customerId) async {
//     if (isFetching) return;
//     setState(() => isFetching = true);

//     log("📌 Scanned Customer ID => $customerId");

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("access_token");
//     log("Access Token => $token");

//     if (token == null || token.isEmpty) {
//       Get.snackbar("Error", "No access token found. Please login again.");
//       Get.offAll(() => const LoginScreen());
//       return;
//     }

//     var url = Uri.parse(
//       "https://spmetesting.com/api/auth/verify-scanned-customer.php",
//     );

//     var response = await http.post(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/x-www-form-urlencoded",
//         "X-API-ACCESS-TOKEN": token,
//         "X-APP-KEY": "73706d652d6170706c69636174696f6e2d373836",
//       },
//       body: {"customer_id": customerId.trim()},
//     );

//     log("Verify API Response => ${response.body}");
//     log("Verify API Status => ${response.statusCode}");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);

//       if (data["status"] == "success") {
//         Get.to(() => UserDetailScreen(userData: data["data"]));
//       } else {
//         _showErrorDialog(
//           context,
//           title: "Verification Failed",
//           subtitle: data["message"] ?? "Invalid QR code",
//         );
//       }
//     } else if (response.statusCode == 401) {
//       // ✅ Token expired case
//       _showErrorDialog(
//         context,
//         title: "Your token has expired",
//         subtitle: "Please login again to continue.",
//         showLoginButton: true,
//       );
//     } else {
//       _showErrorDialog(
//         context,
//         title: "Error",
//         subtitle: "Something went wrong. Try again.",
//       );
//     }

//     setState(() => isFetching = false);
//   }

//   /// ❌ Show error dialog when user not found or token expired
//   void _showErrorDialog(
//     BuildContext context, {
//     required String title,
//     required String subtitle,
//     bool showLoginButton = false,
//   }) {
//     setState(() {
//       showErrorOverlay = true;
//       errorTitle = title;
//       errorSubtitle = subtitle;
//       this.showLoginButton = showLoginButton;
//     });
//   }

//   /// ✅ Logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Logout",
//                   style: CustomStyle.infoLabel.copyWith(
//                     color: CustomColor.dot,
//                     fontSize: 22,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Are you sure you want to logout?",
//                   textAlign: TextAlign.center,
//                   style: CustomStyle.infoValue.copyWith(
//                     color: CustomColor.contentText,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text(
//                         "Cancel",
//                         style: CustomStyle.infoValue.copyWith(
//                           color: CustomColor.contentText,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//                         await prefs.remove("access_token");
//                         Get.offAll(() => const LoginScreen());
//                       },
//                       child: const Text("OK", style: TextStyle(fontSize: 16)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   late AnimationController _animController;
//   late Animation<double> _positionAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//     _positionAnimation = Tween<double>(
//       begin: -1,
//       end: 1,
//     ).animate(_animController);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       controller.stop();
//     }
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       controller.start();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double boxWidth = MediaQuery.of(context).size.width * 0.80;
//     final double boxHeight = MediaQuery.of(context).size.height * 0.35;
//     const double topOffset = 170;

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             /// 📷 Scanner
//             MobileScanner(
//               controller: controller,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 for (final barcode in barcodes) {
//                   if (barcode.rawValue != null && !isFetching) {
//                     qrResult = barcode.rawValue;
//                     verifyCustomer(qrResult!);
//                   }
//                 }
//               },
//             ),

//             /// 🔵 Overlay
//             ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 CustomColor.screenBackground,
//                 BlendMode.srcOut,
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.black,
//                       backgroundBlendMode: BlendMode.dstOut,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: topOffset),
//                       child: Container(
//                         width: boxWidth,
//                         height: boxHeight,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// 🔴 Animated line
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: AnimatedBuilder(
//                     animation: _positionAnimation,
//                     builder: (context, child) {
//                       return Align(
//                         alignment: Alignment(0, _positionAnimation.value),
//                         child: Container(
//                           width: boxWidth,
//                           height: 3,
//                           color: Colors.red,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔙 Logout
//             Positioned(
//               top: 10,
//               right: 10,
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.logout_outlined,
//                   color: CustomColor.mainText,
//                   size: 25,
//                 ),
//                 onPressed: () => _showLogoutDialog(context),
//               ),
//             ),

//             /// 📏 Zoom + Scan button
//             /// 📏 Zoom + Manual Scan Button
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// 📏 Zoom Slider
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.remove, color: CustomColor.slider),
//                           Expanded(
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 // thumbShape: const ShadowSliderThumbShape(
//                                 //   thumbRadius: 6,
//                                 // ),
//                               ),
//                               child: Slider(
//                                 value: zoomValue,
//                                 min: 0.0,
//                                 max: 1.0,
//                                 activeColor: Colors.red,
//                                 onChanged: (val) async {
//                                   setState(() => zoomValue = val);
//                                   await controller.setZoomScale(val);
//                                 },
//                               ),
//                             ),
//                           ),
//                           const Icon(Icons.add, color: CustomColor.slider),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     /// 🔘 Manual Scan Button
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: GestureDetector(
//                         onTap: () {
//                           if (qrResult != null && qrResult!.isNotEmpty) {
//                             verifyCustomer(qrResult!);
//                           } else {
//                             Get.snackbar("Error", "No QR code scanned yet!");
//                           }
//                         },
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             final screenWidth = MediaQuery.of(
//                               context,
//                             ).size.width;

//                             return SizedBox(
//                               width:
//                                   screenWidth * 0.9, // screen ka 90% width lega
//                               height: 60, // fixed but responsive height
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: CustomColor.mainText,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     left:
//                                         screenWidth *
//                                         0.35, // image center-ish rakho
//                                     top: -30,
//                                     child: Image.asset(
//                                       "assets/images/QR.1.png",
//                                       width:
//                                           screenWidth *
//                                           0.2, // responsive image size
//                                       height: screenWidth * 0.2,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),

//                     // Padding(
//                     //   padding: const EdgeInsets.all(20),
//                     //   child: SizedBox(
//                     //     width: 364,
//                     //     height: 67,
//                     //     child: GestureDetector(
//                     //       onTap: () {
//                     //         if (qrResult != null && qrResult!.isNotEmpty) {
//                     //           verifyCustomer(qrResult!);
//                     //         } else {
//                     //           Get.snackbar("Error", "No QR code scanned yet!");
//                     //         }
//                     //       },
//                     //       child: Stack(
//                     //         clipBehavior: Clip.none,
//                     //         children: [
//                     //           Container(
//                     //             decoration: BoxDecoration(
//                     //               color: CustomColor.mainText,
//                     //               borderRadius: BorderRadius.circular(12),
//                     //             ),
//                     //           ),
//                     //           Positioned(
//                     //             left: 130,
//                     //             top: -40,
//                     //             child: Image.asset(
//                     //               "assets/images/QR.1.png",
//                     //               width: 90,
//                     //               height: 90,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),

//             if (showErrorOverlay) ...[
//               Positioned.fill(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                   child: Container(color: Colors.black.withOpacity(0.3)),
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         "assets/images/error_info.png",
//                         width: 60,
//                         height: 60,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         errorTitle,
//                         style: CustomStyle.mainText.copyWith(
//                           color: CustomColor.contentText,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         errorSubtitle,
//                         style: CustomStyle.infoValue.copyWith(
//                           color: CustomColor.contentText,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 25),
//                       if (showLoginButton)
//                         CustomButton(
//                           text: "Login Again",
//                           onPressed: () {
//                             Get.offAll(() => const LoginScreen());
//                           },
//                         )
//                       else
//                         CustomButton(
//                           text: "Scan More",
//                           onPressed: () {
//                             setState(() => showErrorOverlay = false);
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:bmw_passes/constants/custom_button.dart';
// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:bmw_passes/screens/home/user_detail_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../constants/custom_style.dart';

// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});

//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }

// class _QrScanScreenState extends State<QrScanScreen>
//     with SingleTickerProviderStateMixin {
//   final MobileScannerController controller = MobileScannerController();
//   String? qrResult;
//   double zoomValue = 0.0;
//   bool isFetching = false;
//   bool showErrorOverlay = false;
//   String errorTitle = "";
//   String errorSubtitle = "";

//   /// ✅ Verify customer by QR result
//   Future<void> verifyCustomer(String customerId) async {
//     if (isFetching) return;
//     setState(() => isFetching = true);

//     log("📌 Scanned Customer ID => $customerId");

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("access_token");
//     log("Access Token => $token");

//     if (token == null || token.isEmpty) {
//       Get.snackbar("Error", "No access token found. Please login again.");
//       Get.offAll(() => const LoginScreen());
//       return;
//     }

//     var url = Uri.parse(
//       "https://spmetesting.com/api/auth/verify-scanned-customer.php",
//     );

//     var response = await http.post(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/x-www-form-urlencoded",
//         "X-API-ACCESS-TOKEN": token,
//         "X-APP-KEY": "73706d652d6170706c69636174696f6e2d373836",
//       },
//       body: {"customer_id": customerId.trim()},
//     );

//     log("Verify API Response => ${response.body}");
//     log("Verify API Token => $token");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       var data = jsonDecode(response.body);

//       if (data["status"] == "success") {
//         /// ✅ User mil gaya
//         Get.to(() => UserDetailScreen(userData: data["data"]));
//       } else if (data["message"].toString().toLowerCase().contains("token")) {
//         /// 🔴 Token expired / dusri device se login
//         _showErrorDialog(
//           context,
//           "Your token has expired. Please login again.",
//         );

//         /// ✅ force logout
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove("access_token");

//         Future.delayed(const Duration(seconds: 2), () {
//           Get.offAll(() => const LoginScreen());
//         });
//       } else {
//         /// ❌ QR ghalat ya user not found
//         _showErrorDialog(context, data["message"] ?? "Customer not found");
//       }
//     } else {
//       _showErrorDialog(context, "Oops! User not found");
//     }
//     setState(() => isFetching = false);
//   }

//   /// ❌ Show error dialog
//   void _showErrorDialog(BuildContext context, String message) {
//     setState(() {
//       showErrorOverlay = true;
//       errorTitle = "Verification Failed";
//       errorSubtitle = message;
//     });

//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         setState(() => showErrorOverlay = false);
//       }
//     });
//   }

//   /// ✅ Logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Logout",
//                   style: CustomStyle.infoLabel.copyWith(
//                     color: CustomColor.dot,
//                     fontSize: 22,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Are you sure you want to logout?",
//                   textAlign: TextAlign.center,
//                   style: CustomStyle.infoValue.copyWith(
//                     color: CustomColor.contentText,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 25,
//                           vertical: 12,
//                         ),
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text(
//                         "Cancel",
//                         style: CustomStyle.infoValue.copyWith(
//                           color: CustomColor.contentText,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 12,
//                         ),
//                       ),
//                       onPressed: () async {
//                         Navigator.of(context).pop();

//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//                         await prefs.remove("access_token");

//                         Get.offAll(() => const LoginScreen());
//                       },
//                       child: const Text("OK", style: TextStyle(fontSize: 16)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   late AnimationController _animController;
//   late Animation<double> _positionAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _positionAnimation = Tween<double>(
//       begin: -1,
//       end: 1,
//     ).animate(_animController);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       controller.stop();
//     }
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       controller.start();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double boxWidth = MediaQuery.of(context).size.width * 0.80;
//     final double boxHeight = MediaQuery.of(context).size.height * 0.35;
//     const double topOffset = 170;

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             /// 📷 Camera Scanner
//             MobileScanner(
//               controller: controller,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 for (final barcode in barcodes) {
//                   if (barcode.rawValue != null && !isFetching) {
//                     qrResult = barcode.rawValue;
//                     verifyCustomer(qrResult!);
//                   }
//                 }
//               },
//             ),

//             /// 🌓 Overlay
//             ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 CustomColor.screenBackground,
//                 BlendMode.srcOut,
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.black,
//                       backgroundBlendMode: BlendMode.dstOut,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: topOffset),
//                       child: Container(
//                         width: boxWidth,
//                         height: boxHeight,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// 🔵 Blue corners
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: Stack(
//                     children: [
//                       _buildCorner(Alignment.topLeft),
//                       _buildCorner(Alignment.topRight),
//                       _buildCorner(Alignment.bottomLeft),
//                       _buildCorner(Alignment.bottomRight),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔴 Animated Red Line
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: AnimatedBuilder(
//                     animation: _positionAnimation,
//                     builder: (context, child) {
//                       return Align(
//                         alignment: Alignment(0, _positionAnimation.value),
//                         child: Container(
//                           width: boxWidth,
//                           height: 3,
//                           color: Colors.red,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔙 Back & Logout
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.logout_outlined,
//                       color: CustomColor.mainText,
//                       size: 25,
//                     ),
//                     onPressed: () => _showLogoutDialog(context),
//                   ),
//                 ],
//               ),
//             ),

//             /// 📏 Zoom + Manual Scan
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// 📏 Zoom Slider
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.remove, color: CustomColor.slider),
//                           Expanded(
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 thumbShape: const ShadowSliderThumbShape(
//                                   thumbRadius: 6,
//                                 ),
//                               ),
//                               child: Slider(
//                                 value: zoomValue,
//                                 min: 0.0,
//                                 max: 1.0,
//                                 activeColor: Colors.red,
//                                 onChanged: (val) async {
//                                   setState(() => zoomValue = val);
//                                   await controller.setZoomScale(val);
//                                 },
//                               ),
//                             ),
//                           ),
//                           const Icon(Icons.add, color: CustomColor.slider),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     /// 🔘 Manual Scan Button
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: GestureDetector(
//                         onTap: () {
//                           if (qrResult != null && qrResult!.isNotEmpty) {
//                             verifyCustomer(qrResult!);
//                           } else {
//                             Get.snackbar("Error", "No QR code scanned yet!");
//                           }
//                         },
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             final screenWidth = MediaQuery.of(
//                               context,
//                             ).size.width;

//                             return SizedBox(
//                               width: screenWidth * 0.9,
//                               height: 60,
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: CustomColor.mainText,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     left: screenWidth * 0.35,
//                                     top: -30,
//                                     child: Image.asset(
//                                       "assets/images/QR.1.png",
//                                       width: screenWidth * 0.2,
//                                       height: screenWidth * 0.2,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             if (showErrorOverlay) ...[
//               Positioned.fill(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                   child: Container(color: Colors.black.withOpacity(0.3)),
//                 ),
//               ),
//               Positioned(
//                 top:
//                     MediaQuery.of(context).size.height *
//                     0.19, // jitna upar/below rakhna ho
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   height: 300,
//                   padding: const EdgeInsets.all(26),
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 49,
//                   ), // thoda safe margin
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         "assets/images/error_info.png",
//                         width: 60,
//                         height: 60,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         errorSubtitle.isNotEmpty
//                             ? errorSubtitle
//                             : "Oops! User not found",
//                         style: CustomStyle.mainText.copyWith(
//                           color: CustomColor.contentText,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 25),
//                       SizedBox(
//                         width: 200,
//                         child: CustomButton(
//                           text: "Scan More",
//                           onPressed: () {
//                             setState(() => showErrorOverlay = false);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔵 Build corner edges
//   Widget _buildCorner(Alignment alignment) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           border: Border(
//             top:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.topRight
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//             left:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.bottomLeft
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//             right:
//                 alignment == Alignment.topRight ||
//                     alignment == Alignment.bottomRight
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//             bottom:
//                 alignment == Alignment.bottomLeft ||
//                     alignment == Alignment.bottomRight
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ✅ Custom slider thumb
// class ShadowSliderThumbShape extends SliderComponentShape {
//   final double thumbRadius;

//   const ShadowSliderThumbShape({this.thumbRadius = 8});

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(thumbRadius);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     final Canvas canvas = context.canvas;

//     final shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(0.3)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

//     canvas.drawCircle(center, thumbRadius + 2, shadowPaint);

//     final thumbPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.red;
//     canvas.drawCircle(center, thumbRadius, thumbPaint);
//   }
// }

//final code

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:bmw_passes/constants/custom_button.dart';
// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:bmw_passes/screens/auth/login_screen.dart';
// import 'package:bmw_passes/screens/home/user_detail_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../constants/custom_style.dart';

// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});

//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }

// class _QrScanScreenState extends State<QrScanScreen>
//     with SingleTickerProviderStateMixin {
//   final MobileScannerController controller = MobileScannerController();
//   String? qrResult;
//   double zoomValue = 0.0;
//   bool isFetching = false;
//   bool showErrorOverlay = false;
//   String errorTitle = "";
//   String errorSubtitle = "";

//   /// ✅ Verify customer by QR result
//   Future<void> verifyCustomer(String customerId) async {
//     if (isFetching) return;
//     setState(() => isFetching = true);

//     log("📌 Scanned Customer ID => $customerId");

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("access_token");
//     log("Access Token => $token");

//     if (token == null || token.isEmpty) {
//       Get.snackbar("Error", "No access token found. Please login again.");
//       Get.offAll(() => const LoginScreen());
//       return;
//     }

//     var url = Uri.parse(
//       "https://spmetesting.com/api/auth/verify-scanned-customer.php",
//     );

//     var response = await http.post(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/x-www-form-urlencoded",
//         "X-API-ACCESS-TOKEN": token,
//         "X-APP-KEY": "73706d652d6170706c69636174696f6e2d373836",
//       },
//       body: {"customer_id": customerId.trim()},
//     );

//     log("Verify API Response => ${response.body}");
//     log("Verify API Token => $token");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       var data = jsonDecode(response.body);

//       if (data["status"] == "success") {
//         /// ✅ User mil gaya
//         Get.to(() => UserDetailScreen(userData: data["data"]));
//       } else if (data["message"].toString().toLowerCase().contains("token")) {
//         /// 🔴 Token expired (dusri device se login hua)
//         await _handleTokenExpired();
//       } else {
//         /// ❌ QR ghalat ya user not found
//         _showErrorDialog(context, data["message"] ?? "Customer not found");
//       }
//     } else if (response.statusCode == 401) {
//       /// ✅ 401 Unauthorized -> Token expired
//       await _handleTokenExpired();
//     } else {
//       _showErrorDialog(context, "Oops! User not found");
//     }

//     setState(() => isFetching = false);
//   }

//   /// 🔴 Handle token expiry
//   Future<void> _handleTokenExpired() async {
//     _showErrorDialog(
//       context,
//       "Your token has expired. Please login again.",
//       showLoginButton: true,
//     );
//   }

//   /// ❌ Show error dialog (popup UI same as your design)
//   void _showErrorDialog(
//     BuildContext context,
//     String message, {
//     bool showLoginButton = false,
//   }) {
//     setState(() {
//       showErrorOverlay = true;
//       errorTitle = "Verification Failed";
//       errorSubtitle = message;
//     });

//     // Normal error -> auto hide
//     if (!showLoginButton) {
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted) {
//           setState(() => showErrorOverlay = false);
//         }
//       });
//     }
//   }

//   /// ✅ Logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Logout",
//                   style: CustomStyle.infoLabel.copyWith(
//                     color: CustomColor.dot,
//                     fontSize: 22,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Are you sure you want to logout?",
//                   textAlign: TextAlign.center,
//                   style: CustomStyle.infoValue.copyWith(
//                     color: CustomColor.contentText,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 25,
//                           vertical: 12,
//                         ),
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text(
//                         "Cancel",
//                         style: CustomStyle.infoValue.copyWith(
//                           color: CustomColor.contentText,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 12,
//                         ),
//                       ),
//                       onPressed: () async {
//                         Navigator.of(context).pop();

//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//                         await prefs.remove("access_token");

//                         Get.offAll(() => const LoginScreen());
//                       },
//                       child: const Text("OK", style: TextStyle(fontSize: 16)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   late AnimationController _animController;
//   late Animation<double> _positionAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _positionAnimation = Tween<double>(
//       begin: -1,
//       end: 1,
//     ).animate(_animController);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       controller.stop();
//     }
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       controller.start();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double boxWidth = MediaQuery.of(context).size.width * 0.80;
//     final double boxHeight = MediaQuery.of(context).size.height * 0.35;
//     const double topOffset = 170;

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             /// 📷 Camera Scanner
//             MobileScanner(
//               controller: controller,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 for (final barcode in barcodes) {
//                   if (barcode.rawValue != null && !isFetching) {
//                     qrResult = barcode.rawValue;
//                     verifyCustomer(qrResult!);
//                   }
//                 }
//               },
//             ),

//             /// 🌓 Overlay
//             ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 CustomColor.screenBackground,
//                 BlendMode.srcOut,
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.black,
//                       backgroundBlendMode: BlendMode.dstOut,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: topOffset),
//                       child: Container(
//                         width: boxWidth,
//                         height: boxHeight,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// 🔵 Blue corners
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: Stack(
//                     children: [
//                       _buildCorner(Alignment.topLeft),
//                       _buildCorner(Alignment.topRight),
//                       _buildCorner(Alignment.bottomLeft),
//                       _buildCorner(Alignment.bottomRight),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔴 Animated Red Line
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topOffset),
//                 child: SizedBox(
//                   width: boxWidth,
//                   height: boxHeight,
//                   child: AnimatedBuilder(
//                     animation: _positionAnimation,
//                     builder: (context, child) {
//                       return Align(
//                         alignment: Alignment(0, _positionAnimation.value),
//                         child: Container(
//                           width: boxWidth,
//                           height: 3,
//                           color: Colors.red,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             /// 🔙 Back & Logout
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.logout_outlined,
//                       color: CustomColor.mainText,
//                       size: 25,
//                     ),
//                     onPressed: () => _showLogoutDialog(context),
//                   ),
//                 ],
//               ),
//             ),

//             /// 📏 Zoom + Manual Scan
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// 📏 Zoom Slider
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.remove, color: CustomColor.slider),
//                           Expanded(
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 thumbShape: const ShadowSliderThumbShape(
//                                   thumbRadius: 6,
//                                 ),
//                               ),
//                               child: Slider(
//                                 value: zoomValue,
//                                 min: 0.0,
//                                 max: 1.0,
//                                 activeColor: Colors.red,
//                                 onChanged: (val) async {
//                                   setState(() => zoomValue = val);
//                                   await controller.setZoomScale(val);
//                                 },
//                               ),
//                             ),
//                           ),
//                           const Icon(Icons.add, color: CustomColor.slider),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     /// 🔘 Manual Scan Button
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: GestureDetector(
//                         onTap: () {
//                           if (qrResult != null && qrResult!.isNotEmpty) {
//                             verifyCustomer(qrResult!);
//                           } else {
//                             Get.snackbar("Error", "No QR code scanned yet!");
//                           }
//                         },
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             final screenWidth = MediaQuery.of(
//                               context,
//                             ).size.width;
//                             return SizedBox(
//                               width: screenWidth * 0.9,
//                               height: 60,
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: CustomColor.mainText,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     left: screenWidth * 0.35,
//                                     top: -30,
//                                     child: Image.asset(
//                                       "assets/images/QR.1.png",
//                                       width: screenWidth * 0.2,
//                                       height: screenWidth * 0.2,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             /// ❌ Error Overlay
//             if (showErrorOverlay) ...[
//               Positioned.fill(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                   child: Container(color: Colors.black.withOpacity(0.3)),
//                 ),
//               ),
//               Positioned(
//                 top: MediaQuery.of(context).size.height * 0.19,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   height: 300,
//                   padding: const EdgeInsets.all(26),
//                   margin: const EdgeInsets.symmetric(horizontal: 49),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         "assets/images/error_info.png",
//                         width: 60,
//                         height: 60,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         errorSubtitle.isNotEmpty
//                             ? errorSubtitle
//                             : "Oops! User not found",
//                         style: CustomStyle.mainText.copyWith(
//                           color: CustomColor.contentText,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 25),
//                       SizedBox(
//                         width: 200,
//                         child: CustomButton(
//                           text: errorSubtitle.contains("expired")
//                               ? "Login Again"
//                               : "Scan More",
//                           onPressed: () async {
//                             if (errorSubtitle.contains("expired")) {
//                               SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();
//                               await prefs.remove("access_token");

//                               if (mounted)
//                                 Get.offAll(() => const LoginScreen());
//                             } else {
//                               setState(() => showErrorOverlay = false);
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔵 Build corner edges
//   Widget _buildCorner(Alignment alignment) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           border: Border(
//             top:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.topRight
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//             left:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.bottomLeft
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//             right:
//                 alignment == Alignment.topRight ||
//                     alignment == Alignment.bottomRight
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//             bottom:
//                 alignment == Alignment.bottomLeft ||
//                     alignment == Alignment.bottomRight
//                 ? const BorderSide(color: CustomColor.mainText, width: 15)
//                 : BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ✅ Custom slider thumb
// class ShadowSliderThumbShape extends SliderComponentShape {
//   final double thumbRadius;

//   const ShadowSliderThumbShape({this.thumbRadius = 8});

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(thumbRadius);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     final Canvas canvas = context.canvas;

//     final shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(0.3)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

//     canvas.drawCircle(center, thumbRadius + 2, shadowPaint);

//     final thumbPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.red;
//     canvas.drawCircle(center, thumbRadius, thumbPaint);
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:bmw_passes/constants/custom_button.dart';
import 'package:bmw_passes/constants/custom_color.dart';
import 'package:bmw_passes/screens/auth/login_screen.dart';
import 'package:bmw_passes/screens/home/user_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/custom_style.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  String? qrResult;
  double zoomValue = 0.0;
  bool isFetching = false;
  bool showErrorOverlay = false;
  String errorTitle = "";
  String errorSubtitle = "";

  /// ✅ Verify customer by QR result
  Future<void> verifyCustomer(String customerId) async {
    if (isFetching) return;
    setState(() => isFetching = true);

    log("📌 Scanned Customer ID => $customerId");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("Access Token => $token");

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "No access token found. Please login again.");
      Get.offAll(() => const LoginScreen());
      return;
    }

    var url = Uri.parse(
      "https://spmetesting.com/api/auth/verify-scanned-customer.php",
    );

    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "X-API-ACCESS-TOKEN": token,
        "X-APP-KEY": "73706d652d6170706c69636174696f6e2d373836",
      },
      body: {"customer_id": customerId.trim()},
    );

    log("Verify API Response => ${response.body}");
    log("Verify API Token => $token");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        /// ✅ User found
        Get.to(() => UserDetailScreen(userData: data["data"]));
      } else if (data["message"].toString().toLowerCase().contains("token")) {
        /// 🔴 Token expired
        await _handleTokenExpired();
      } else {
        /// ❌ Wrong QR / User not found
        _showErrorDialog(context, "User not found");
      }
    } else if (response.statusCode == 401) {
      /// 🔴 Token expired
      await _handleTokenExpired();
    } else {
      _showErrorDialog(context, "Oops! User not found");
    }

    // ✅ Clear previous QR result after processing
    setState(() {
      isFetching = false;
      qrResult = null;
    });
  }

  /// 🔴 Handle token expiry
  Future<void> _handleTokenExpired() async {
    _showErrorDialog(
      context,
      "Your token has expired. Please login again.",
      showLoginButton: true,
    );
  }

  /// ❌ Show error dialog
  void _showErrorDialog(
    BuildContext context,
    String message, {
    bool showLoginButton = false,
  }) {
    setState(() {
      showErrorOverlay = true;
      errorTitle = "Verification Failed";
      errorSubtitle = message;
      qrResult = null; // Reset QR result here as well
    });

    if (!showLoginButton) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => showErrorOverlay = false);
      });
    }
  }

  /// ✅ Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Logout",
                  style: CustomStyle.infoLabel.copyWith(
                    color: CustomColor.dot,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Are you sure you want to logout?",
                  textAlign: TextAlign.center,
                  style: CustomStyle.infoValue.copyWith(
                    color: CustomColor.contentText,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: CustomStyle.infoValue.copyWith(
                          color: CustomColor.contentText,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove("access_token");

                        Get.offAll(() => const LoginScreen());
                      },
                      child: const Text("OK", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late AnimationController _animController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Reset QR result when screen is loaded
    qrResult = null;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _positionAnimation = Tween<double>(
      begin: -1,
      end: 1,
    ).animate(_animController);
  }

  @override
  void dispose() {
    controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (defaultTargetPlatform == TargetPlatform.android) controller.stop();
    if (defaultTargetPlatform == TargetPlatform.iOS) controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80;
    final double boxHeight = MediaQuery.of(context).size.height * 0.35;
    const double topOffset = 170;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// 📷 Camera Scanner
            MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null && !isFetching) {
                    qrResult = barcode.rawValue;
                    verifyCustomer(qrResult!);
                  }
                }
              },
            ),

            /// 🌓 Overlay
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                CustomColor.screenBackground,
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: topOffset),
                      child: Container(
                        width: boxWidth,
                        height: boxHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔵 Blue corners
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: topOffset),
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: Stack(
                    children: [
                      _buildCorner(Alignment.topLeft),
                      _buildCorner(Alignment.topRight),
                      _buildCorner(Alignment.bottomLeft),
                      _buildCorner(Alignment.bottomRight),
                    ],
                  ),
                ),
              ),
            ),

            /// 🔴 Animated Red Line
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: topOffset),
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: AnimatedBuilder(
                    animation: _positionAnimation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment(0, _positionAnimation.value),
                        child: Container(
                          width: boxWidth,
                          height: 3,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            /// 🔙 Back & Logout
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: CustomColor.mainText,
                      size: 25,
                    ),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),

            /// 📏 Zoom + Manual Scan
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 📏 Zoom Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.remove, color: CustomColor.slider),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: const ShadowSliderThumbShape(
                                  thumbRadius: 6,
                                ),
                              ),
                              child: Slider(
                                value: zoomValue,
                                min: 0.0,
                                max: 1.0,
                                activeColor: Colors.red,
                                onChanged: (val) async {
                                  setState(() => zoomValue = val);
                                  await controller.setZoomScale(val);
                                },
                              ),
                            ),
                          ),
                          const Icon(Icons.add, color: CustomColor.slider),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔘 Manual Scan Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () {
                          if (qrResult != null && qrResult!.isNotEmpty) {
                            verifyCustomer(qrResult!);
                          } else {
                            Get.snackbar("Error", "No QR code scanned yet!");
                          }
                        },
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth = MediaQuery.of(
                              context,
                            ).size.width;
                            return SizedBox(
                              width: screenWidth * 0.9,
                              height: 60,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: CustomColor.mainText,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Positioned(
                                    left: screenWidth * 0.35,
                                    top: -30,
                                    child: Image.asset(
                                      "assets/images/QR.1.png",
                                      width: screenWidth * 0.2,
                                      height: screenWidth * 0.2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ❌ Error Overlay
            if (showErrorOverlay) ...[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.19,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 300,
                  padding: const EdgeInsets.all(26),
                  margin: const EdgeInsets.symmetric(horizontal: 49),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/error_info.png",
                        width: 60,
                        height: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        errorSubtitle.isNotEmpty
                            ? errorSubtitle
                            : "Oops! User not found",
                        style: CustomStyle.mainText.copyWith(
                          color: CustomColor.contentText,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 200,
                        child: CustomButton(
                          text: errorSubtitle.contains("expired")
                              ? "Login Again"
                              : "Scan More",
                          onPressed: () async {
                            if (errorSubtitle.contains("expired")) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove("access_token");

                              if (mounted)
                                Get.offAll(() => const LoginScreen());
                            } else {
                              setState(() => showErrorOverlay = false);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 🔵 Build corner edges
  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(color: CustomColor.mainText, width: 15)
                : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(color: CustomColor.mainText, width: 15)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: CustomColor.mainText, width: 15)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: CustomColor.mainText, width: 15)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// ✅ Custom slider thumb
class ShadowSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const ShadowSliderThumbShape({this.thumbRadius = 8});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, thumbRadius + 2, shadowPaint);

    final thumbPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.red;
    canvas.drawCircle(center, thumbRadius, thumbPaint);
  }
}
