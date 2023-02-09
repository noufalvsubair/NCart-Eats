import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppBottomDropdown extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String value;
  final TextStyle? valueStyle;
  final double? dotPadding;
  final double? valuePadding;
  final VoidCallback onTapped;
  final bool? dotEnabled;

  const AppBottomDropdown(
      {Key? key,
      required this.value,
      required this.onTapped,
      this.valueStyle,
      this.title = "",
      this.titleStyle,
      this.dotPadding = 10,
      this.valuePadding = 10,
      this.dotEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                  color: AppColors.textLowEmphasisColor,
                  shape: BoxShape.circle)),
          if (title!.isNotEmpty)
            Padding(
                padding:
                    EdgeInsets.only(left: dotPadding!, right: valuePadding!),
                child: Text(title!,
                    style: titleStyle ??
                        GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHighestEmphasisColor,
                            fontSize: 11))),
          InkWell(
              onTap: onTapped,
              child: Row(children: [
                Text(value,
                    style: valueStyle ??
                        GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                            color: AppColors.textHighestEmphasisColor,
                            fontSize: 11)),
                Icon(Icons.arrow_drop_down,
                    size: 15, color: AppColors.primaryColor)
              ]))
        ]);
  }
}
