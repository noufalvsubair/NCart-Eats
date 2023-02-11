import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/widget/app_button.dart';

class AppDishReplaceDialog extends StatelessWidget {
  final String cartShopName;
  final String currentShopName;
  final VoidCallback onReplaceTapped;
  final VoidCallback onNoTapped;

  const AppDishReplaceDialog(
      {Key? key,
      required this.cartShopName,
      required this.currentShopName,
      required this.onReplaceTapped,
      required this.onNoTapped})
      : super(key: key);

  Widget _buildTitleTextWidget(BuildContext context) =>
      Text(S.of(context).replaceCartItem,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textHighestEmphasisColor));

  Widget _buildDescriptionTextWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
          S
              .of(context)
              .replaceCartItemDescription(cartShopName, currentShopName),
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.textMedEmphasisColor)));

  Widget _buildBottomButtonContainerWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton(
                width: 130,
                height: 40,
                label: S.of(context).no,
                type: ButtonType.secondary.toString(),
                onTapped: onNoTapped),
            AppButton(
                width: 130,
                height: 40,
                label: S.of(context).replace,
                type: ButtonType.primary.toString(),
                onTapped: onReplaceTapped)
          ]));

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
            width: 300,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleTextWidget(context),
                  _buildDescriptionTextWidget(context),
                  _buildBottomButtonContainerWidget(context)
                ])));
  }
}
