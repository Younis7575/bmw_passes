// import 'package:bmw_passes/constants/custom_style.dart';
// import 'package:flutter/material.dart';
// // import 'constants/custom_style.dart';

// class InfoCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final Widget? leading;

//   const InfoCard({
//     super.key,
//     required this.label,
//     required this.value,
//     this.leading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue.withOpacity(0.3)),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           if (leading != null) ...[leading!, const SizedBox(width: 8)],
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label, style: CustomStyle.loginText),
//                 const SizedBox(height: 2),
//                 Text(value, style: CustomStyle.contentText),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:bmw_passes/constants/custom_style.dart';

// class InfoCard extends StatelessWidget {
//   final String leftLabel;
//   final String rightLabel;
//   final String? imagePath;

//   const InfoCard({
//     super.key,
//     required this.leftLabel,
//     required this.rightLabel,
//     this.imagePath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue.withOpacity(0.3)),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // ✅ Left label
//           Text(leftLabel, style: CustomStyle.loginText),

//           // ✅ Center image
//           if (imagePath != null) Image.asset(imagePath!, width: 30, height: 30),

//           // ✅ Right label
//           Text(rightLabel, style: CustomStyle.contentText),
//         ],
//       ),
//     );
//   }
// }
