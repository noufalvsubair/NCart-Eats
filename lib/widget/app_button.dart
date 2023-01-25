import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/resources/app_colors.dart';

ButtonStyle primaryButtonStyle = TextButton.styleFrom(
    backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white);

ButtonStyle secondaryButtonStyle =
    TextButton.styleFrom(foregroundColor: AppColors.primaryColor);

class AppButton extends StatelessWidget {
  final String label;
  final String type;
  final VoidCallback onTapped;
  final double? width;
  final double? height;
  final IconData? icon;

  const AppButton(
      {Key? key,
      required this.label,
      required this.type,
      required this.onTapped,
      this.width,
      this.height = 45,
      this.icon})
      : super(key: key);

  Widget _buildButtonTextWidget() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(icon,
                      color: type == ButtonType.primary.toString()
                          ? Colors.white
                          : AppColors.primaryColor)),
            Text(label,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: type == ButtonType.primary.toString()
                        ? AppColors.backgroundPrimaryColor
                        : AppColors.primaryColor))
          ]);

  Widget _buildTextButtonWidget() => TextButton(
      onPressed: onTapped,
      style: type == ButtonType.secondary.toString()
          ? secondaryButtonStyle
          : primaryButtonStyle,
      child: _buildButtonTextWidget());

  Widget _buildOutlinedButtonWidget() => OutlinedButton(
      onPressed: onTapped,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
        backgroundColor:
            MaterialStateProperty.resolveWith<Color>((states) => Colors.white),
        side: MaterialStateProperty.resolveWith(
            (states) => BorderSide(color: AppColors.primaryColor, width: 1)),
      ),
      child: _buildButtonTextWidget());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width ?? MediaQuery.of(context).size.width - 40,
        child: type == ButtonType.tertiary.toString()
            ? _buildOutlinedButtonWidget()
            : _buildTextButtonWidget());
  }
}
