import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppVerticalLabelIconCard extends StatelessWidget {
  final Color? backgroundColor;
  final String label;
  final IconData? icon;
  final String? svgIcon;
  final TextStyle? textStyle;
  final double? borderRadius;
  final double? width;
  final double? height;
  final VoidCallback onTapped;

  const AppVerticalLabelIconCard(
      {Key? key,
      this.backgroundColor = Colors.white,
      required this.label,
      this.icon,
      this.textStyle,
      this.borderRadius = 10,
      this.width,
      this.height = 80,
      required this.onTapped,
      this.svgIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTapped,
        child: SizedBox(
            width: width ?? (MediaQuery.of(context).size.width - 30) / 3,
            height: height,
            child: Card(
                elevation: 0,
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (svgIcon != null && svgIcon!.isNotEmpty)
                        SvgPicture.asset(svgIcon!, width: 16, height: 16),
                      if (icon != null)
                        Icon(icon,
                            color: AppColors.textHighestEmphasisColor,
                            size: 15),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(label,
                              style: textStyle ??
                                  GoogleFonts.roboto(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color:
                                          AppColors.textHighestEmphasisColor)))
                    ]))));
  }
}
