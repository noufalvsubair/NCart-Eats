import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/resources/app_colors.dart';

ButtonStyle primaryButtonStyle = TextButton.styleFrom(
    backgroundColor: AppColors.themeColor, foregroundColor: Colors.white);

ButtonStyle secondaryButtonStyle =
    TextButton.styleFrom(foregroundColor: AppColors.themeColor);

class AppButton extends StatelessWidget {
  final String label;
  final String type;
  final VoidCallback onTapped;
  final double? width;
  final double? height;

  const AppButton(
      {Key? key,
      required this.label,
      required this.type,
      required this.onTapped,
      this.width,
      this.height = 45})
      : super(key: key);

  Widget _buildButtonTextWidget() => Text(label,
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: type == ButtonType.primary.toString()
              ? Colors.white
              : AppColors.themeColor));

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
        side: MaterialStateProperty.resolveWith((states) =>
            const BorderSide(color: AppColors.themeColor, width: 1)),
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
