import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppCounterButton extends StatelessWidget {
  final String? label;
  final double? count;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  final Color? counterTextColor;
  final VoidCallback onAddButtonTapped;
  final ValueChanged<double> onUpdateCount;

  const AppCounterButton(
      {Key? key,
      this.label,
      this.count = 0,
      this.buttonStyle,
      this.textStyle,
      required this.onAddButtonTapped,
      required this.onUpdateCount,
      this.counterTextColor})
      : super(key: key);

  Widget _buildElevatedButtonWidget() => ElevatedButton(
      onPressed: () {},
      style: buttonStyle ??
          ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  AppColors.backgroundPrimaryColor)),
      child: Text(label!,
          style: textStyle ??
              GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.positiveColor)));

  Widget _buildCountDecrementButtonWidget() => Padding(
      padding: const EdgeInsets.only(left: 10),
      child: InkWell(
          onTap: () {},
          child: Container(
              width: 10, height: 2.5, color: AppColors.positiveColor)));

  Widget _buildCountTextWidget() => Text("${count!.toInt()}",
      style: textStyle ??
          GoogleFonts.roboto(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: AppColors.positiveColor));

  Widget _buildCountIncrementButtonWidget() => Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
          onTap: () {},
          child: Text("+",
              style: textStyle ??
                  GoogleFonts.roboto(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: AppColors.positiveColor))));

  Widget _buildCounterContainerWidget() => Container(
      width: 90,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: AppColors.backgroundOverlayLightColor,
                offset: const Offset(0.0, 0.5), //(x,y)
                blurRadius: 3.0)
          ]),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCountDecrementButtonWidget(),
            _buildCountTextWidget(),
            _buildCountIncrementButtonWidget()
          ]));

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 90,
      height: 30,
      child: count! > 0
          ? _buildCounterContainerWidget()
          : _buildElevatedButtonWidget());
}
