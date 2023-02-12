import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppStyles {
  static InputDecoration fieldDecorations(BuildContext context, String hint) =>
      InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textMedEmphasisColor),
          border: InputBorder.none,
          counterText: "");

  static InputDecoration fieldDecorationWithIcon(
          BuildContext context, String hint, Widget? icon) =>
      InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textMedEmphasisColor),
          border: InputBorder.none,
          icon: icon!,
          counterText: "");
}
