import 'package:bmw_passes/constants/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStyle {
  static TextStyle mainText = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 0,
    letterSpacing: 0, // 0%
    color: CustomColor.mainText,
  );

  static TextStyle loginText = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w700,
    fontSize: 36,
    height: 0, // 40%
    letterSpacing: 0, // 0%
    color: CustomColor.mainText,
  );

  static TextStyle contentText = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 0, // 100%
    letterSpacing: 0, // 0%
    color: CustomColor.contentText,
  );

  static TextStyle formfield = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 0, // 100%
    letterSpacing: 0, // 0%
    color: CustomColor.contentText,
  );

  static TextStyle buttonText = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 0, // 100%
    letterSpacing: 0, // 0%
    color: CustomColor.contentText,
  );
}
