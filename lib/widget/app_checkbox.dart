import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppCheckbox extends StatelessWidget {
  final bool checked;
  final String? label;
  final ValueChanged<bool?>? onChanged;

  const AppCheckbox(
      {Key? key, required this.checked, this.label, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
              value: checked,
              activeColor: AppColors.primaryColor,
              onChanged: (bool? checked) => onChanged!(checked)),
          Text(label!,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHighestEmphasisColor))
        ]);
  }
}
