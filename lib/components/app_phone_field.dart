import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppPhoneField extends StatelessWidget {
  final TextEditingController fieldEditController;

  const AppPhoneField({Key? key, required this.fieldEditController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("🇮🇳", style: GoogleFonts.encodeSans(fontSize: 16)),
          Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text("+91",
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.normalTextColor))),
          const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_drop_down_outlined,
                  color: Colors.grey, size: 20)),
          Flexible(
              child: TextField(
                  controller: fieldEditController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  cursorColor: AppColors.themeColor,
                  decoration: InputDecoration(
                      hintText: S.of(context).phone,
                      hintStyle: GoogleFonts.encodeSans(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      counterText: "")))
        ]);
  }
}
