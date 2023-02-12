import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppMenuItem extends StatelessWidget {
  final String label;
  final Widget? optionalItem;
  final IconData? icon;
  final String? svgIcon;
  final TextStyle? textStyle;
  final VoidCallback onTapped;
  final EdgeInsets? padding;
  final bool? hasBottomBorder;

  const AppMenuItem({
    Key? key,
    required this.label,
    this.icon,
    this.svgIcon,
    this.textStyle,
    required this.onTapped,
    this.optionalItem,
    this.padding,
    this.hasBottomBorder = false,
  }) : super(key: key);

  Widget _buildMenuIconWidget() => Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: AppColors.backgroundTertiaryColor),
      child: Stack(children: [
        if (svgIcon != null && svgIcon!.isNotEmpty)
          SvgPicture.asset(svgIcon!, width: 12, height: 12),
        if (icon != null)
          Icon(icon, color: AppColors.textHighestEmphasisColor, size: 15)
      ]));

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTapped,
        child: Column(children: [
          Container(
              padding: padding ??
                  const EdgeInsets.only(left: 10, right: 15, top: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildMenuIconWidget(),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(label,
                                  style: textStyle ??
                                      GoogleFonts.raleway(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: AppColors
                                              .textHighestEmphasisColor)))
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (optionalItem != null) optionalItem!,
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.backgroundOverlayDarkColor,
                              size: 14)
                        ])
                  ])),
          if (hasBottomBorder!)
            Padding(
                padding: const EdgeInsets.only(left: 50, top: 10),
                child: Divider(
                    height: 0.5, color: AppColors.backgroundTertiaryColor))
        ]));
  }
}
