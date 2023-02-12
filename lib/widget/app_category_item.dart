import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppCategoryItem extends StatelessWidget {
  final String label;
  final String? type;
  final bool isSelected;
  final VoidCallback onTapped;
  final TextStyle? labelStyle;

  const AppCategoryItem(
      {Key? key,
      required this.label,
      this.type = "",
      required this.isSelected,
      required this.onTapped,
      this.labelStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTapped,
      child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: AppColors.backgroundOverlayLightColor,
                    offset: const Offset(0.0, 0.5), //(x,y)
                    blurRadius: 3.0)
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: isSelected
                  ? AppColors.primarySubColor
                  : AppColors.backgroundPrimaryColor),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (type!.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: GenericWidget.buildDishTypeContainerWidget(
                          type == 'veg')),
                Text(label,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppColors.textHighEmphasisColor)),
                if (isSelected)
                  const Padding(
                      padding: EdgeInsets.only(left: 3),
                      child: Icon(Icons.close, size: 13))
              ])));
}
