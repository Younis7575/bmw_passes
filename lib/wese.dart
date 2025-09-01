// @override
// Widget build(BuildContext context) {
//   final double boxWidth = MediaQuery.of(context).size.width * 0.80;
//   final double boxHeight = MediaQuery.of(context).size.height * 0.35;
//   const double topOffset = 170;

//   return Scaffold(
//     body: SafeArea(
//       child: Stack(
//         children: [
//           /// 📷 Camera Scanner
//           MobileScanner(
//             controller: controller,
//             onDetect: (capture) {
//               final List<Barcode> barcodes = capture.barcodes;
//               for (final barcode in barcodes) {
//                 if (barcode.rawValue != null && !isFetching) {
//                   qrResult = barcode.rawValue;
//                   verifyCustomer(qrResult!); // ✅ call API
//                 }
//               }
//             },
//           ),

//           /// 🔲 Rest of your UI (overlay, corners, buttons, etc.)
//           // ... keep everything you already have ...

//           /// 🚨 Error Overlay
//           if (showErrorOverlay) ...[
//             /// Blur Background
//             Positioned.fill(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                 child: Container(
//                   color: Colors.black.withOpacity(0.3),
//                 ),
//               ),
//             ),

//             /// Red Alert Box
//             Center(
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade700,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       errorTitle,
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       errorSubtitle,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
      
      
      
      
      
//         ],
//       ),
//     ),
//   );
// }
