import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static InputDecoration fieldDecorations(BuildContext context, String hint) =>
      InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          counterText: "");

  static InputDecoration fieldDecorationWithIcon(
          BuildContext context, String hint, Icon? icon) =>
      InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          icon: icon!,
          counterText: "");
}
