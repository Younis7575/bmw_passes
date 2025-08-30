// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:bmw_passes/constants/custom_style.dart';
// import 'package:flutter/material.dart';
//
// class UserDetailScreen extends StatelessWidget {
//   const UserDetailScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Back arrow
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Icon(Icons.arrow_back, color: Colors.blue[800]),
//               ),
//               const SizedBox(height: 20),
//
//               // Profile Image + Verified Badge
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(
//                       "https://i.pravatar.cc/150?img=3",
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.verified,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               // Name + subtitle
//               Text("John Adams", style: CustomStyle.loginText),
//               Text(
//                 "Lorem Ipsum is simply dummy text",
//                 style: CustomStyle.contentText,
//               ),
//               const SizedBox(height: 24),
//
//               // Personal Info Section
//               const SectionTitle(title: "Personal Information"),
//               const InfoCard(
//                 label: "Customer Id:",
//                 value: "BHCHCDVFDYG7e7eee76r7e6rSY",
//               ),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "First Name:", value: "John"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(label: "Last Name:", value: "Adams"),
//                   ),
//                 ],
//               ),
//               const InfoCard(label: "Email:", value: "johnadams7224@gmail.com"),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "Contact:", value: "756756567658"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(
//                       label: "Date Of Birth:",
//                       value: "2001-02-04",
//                     ),
//                   ),
//                 ],
//               ),
//               const InfoCard(label: "Preferred Language:", value: "English"),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "City:", value: "Taxila Cantt"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(
//                       label: "Country/State:",
//                       value: "Atlantic Islands",
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//               const SectionTitle(title: "Others"),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(
//                       label: "Pass Type:  ",
//                       value: "BMW M Accessorized",
//                       leading: Icon(Icons.directions_car, color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "M Model:", value: "4546"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(label: "VIN Model:", value: "5656"),
//                   ),
//                 ],
//               ),
//               const InfoCard(label: "Network ID:", value: "465465768787564"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Section Title
// class SectionTitle extends StatelessWidget {
//   final String title;
//   const SectionTitle({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Text(title, style: CustomStyle.sectionTitle),
//       ),
//     );
//   }
// }
//
// // InfoCard Widget
// class InfoCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final Widget? leading;
//
//   const InfoCard({
//     super.key,
//     required this.label,
//     required this.value,
//     this.leading,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: CustomColor.contentText),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           if (leading != null) ...[leading!, const SizedBox(width: 8)],
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: CustomStyle.infoLabel.copyWith(
//                     color: CustomColor.mainText,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: CustomStyle.infoValue.copyWith(
//                     color: CustomColor.contentText,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:bmw_passes/constants/custom_color.dart';
// import 'package:flutter/material.dart';

// import '../../constants/custom_style.dart';
// import '../../constants/info_card.dart';
// import '../../constants/section_title.dart';

// class UserDetailScreen extends StatelessWidget {
//   const UserDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColor.screenBackground,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Back arrow
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: IconButton(
//                   icon: Icon(Icons.arrow_back, color: CustomColor.mainText),
//                   onPressed: () {
//                     Navigator.pop(context); // Go back to previous screen
//                   },
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Profile Image + Verified Badge
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(
//                       "https://i.pravatar.cc/150?img=3",
//                     ),
//                   ),
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: CustomColor.dot,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     alignment: Alignment.center, // centers the child
//                     child: const Icon(
//                       Icons.verified,
//                       color: CustomColor.screenBackground,
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // Name + subtitle
//               Text("John Adams", style: CustomStyle.loginText),
//               Text(
//                 "Lorem Ipsum is simply dummy text",
//                 style: CustomStyle.contentText,
//               ),
//               const SizedBox(height: 24),

//               // Personal Info Section
//               const SectionTitle(title: "Personal Information"),
//               const InfoCard(
//                 label: "Customer Id:",
//                 value: "BHCHCDVFDYG7e7eee76r7e6rSY",
//               ),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "First Name:", value: "John"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(label: "Last Name:", value: "Adams"),
//                   ),
//                 ],
//               ),
//               const InfoCard(label: "Email:", value: "johnadams7224@gmail.com"),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "Contact:", value: "756756567658"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(
//                       label: "Date Of Birth:",
//                       value: "2001-02-04",
//                     ),
//                   ),
//                 ],
//               ),
//               const InfoCard(label: "Preferred Language:", value: "English"),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "City:", value: "Taxila Cantt"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(
//                       label: "Country/State:",
//                       value: "Atlantic Islands",
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),
//               const SectionTitle(title: "Others"),

//               Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(
//                       label: "Pass Type:",
//                       value: "BMW M Accessorized",
//                       leading: Icon(Icons.directions_car, color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),

//               const Row(
//                 children: [
//                   Expanded(
//                     child: InfoCard(label: "M Model:", value: "4546"),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: InfoCard(label: "VIN Model:", value: "5656"),
//                   ),
//                 ],
//               ),
//               const InfoCard(label: "Network ID:", value: "465465768787564"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:bmw_passes/constants/custom_color.dart';
import 'package:flutter/material.dart';

import '../../constants/custom_style.dart';
import '../../constants/info_card.dart';
import '../../constants/section_title.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final avatarRadius = size.width * 0.18; // responsive avatar size
    final spacing = size.height * 0.02; // responsive vertical spacing

    return Scaffold(
      backgroundColor: CustomColor.screenBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: spacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back arrow
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: CustomColor.mainText),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              SizedBox(height: spacing),

              // Profile Image + Verified Badge
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: const NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ),
                  ),
                  Container(
                    width: avatarRadius * 0.35,
                    height: avatarRadius * 0.35,
                    decoration: BoxDecoration(
                      color: CustomColor.dot,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.verified,
                      color: CustomColor.screenBackground,
                      size: avatarRadius * 0.25,
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing * 0.6),

              // Name + subtitle
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("John Adams", style: CustomStyle.loginText),
              ),
              SizedBox(height: spacing * 0.3),
              Text(
                "Lorem Ipsum is simply dummy text",
                style: CustomStyle.contentText,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: spacing),

              // Personal Info Section
              const SectionTitle(title: "Personal Information"),
              const InfoCard(
                label: "Customer Id:",
                value: "BHCHCDVFDYG7e7eee76r7e6rSY",
              ),
              Row(
                children: const [
                  Expanded(
                    child: InfoCard(label: "First Name:", value: "John"),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(label: "Last Name:", value: "Adams"),
                  ),
                ],
              ),
              const InfoCard(label: "Email:", value: "johnadams7224@gmail.com"),
              Row(
                children: const [
                  Expanded(
                    child: InfoCard(label: "Contact:", value: "756756567658"),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(
                      label: "Date Of Birth:",
                      value: "2001-02-04",
                    ),
                  ),
                ],
              ),
              const InfoCard(label: "Preferred Language:", value: "English"),
              Row(
                children: const [
                  Expanded(
                    child: InfoCard(label: "City:", value: "Taxila Cantt"),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(
                      label: "Country/State:",
                      value: "Atlantic Islands",
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing),
              const SectionTitle(title: "Others"),

              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      label: "Pass Type:",
                      value: "BMW M Accessorized",
                      leading: Icon(
                        Icons.directions_car,
                        color: CustomColor.mainText,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Expanded(
                    child: InfoCard(label: "M Model:", value: "4546"),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(label: "VIN Model:", value: "5656"),
                  ),
                ],
              ),
              const InfoCard(label: "Network ID:", value: "465465768787564"),
            ],
          ),
        ),
      ),
    );
  }
}
