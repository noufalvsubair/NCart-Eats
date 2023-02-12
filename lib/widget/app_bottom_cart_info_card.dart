import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/cart/cart.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppBottomCartInfoCard extends StatelessWidget {
  final List<Cart> carts;
  final String? shopID;

  const AppBottomCartInfoCard({Key? key, required this.carts, this.shopID})
      : super(key: key);

  String _createTotalPriceAndCount(BuildContext context) {
    int totalCount = carts
        .map((Cart cart) => cart.quantity ?? 0)
        .reduce((value, current) => value + current);
    String count = totalCount > 1
        ? S.of(context).items(totalCount)
        : S.of(context).item(totalCount);

    double totalPrice = carts
        .map((Cart cart) => (cart.price! * cart.quantity!.toDouble()))
        .reduce((value, current) => value.toDouble() + current.toDouble());
    Object total = Utilities.isInteger(totalPrice)
        ? totalPrice.toInt()
        : totalPrice.toStringAsFixed(2);

    return "$count |  ₹$total";
  }

  String _createDescription(BuildContext context) =>
      shopID == carts.first.shopID
          ? S.of(context).extraCharges
          : S.of(context).from(carts.first.shopName!);

  Widget _buildCartInfoContainerWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_createTotalPriceAndCount(context),
                style: GoogleFonts.robotoFlex(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.white)),
            Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(_createDescription(context),
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: Colors.white)))
          ]));

  Widget _buildViewCartButtonWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
          onTap: () {},
          child: Text(S.of(context).viewCart,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white))));

  @override
  Widget build(BuildContext context) => SizedBox(
      width: MediaQuery.of(context).size.width - 30,
      height: 50,
      child: Card(
          margin: EdgeInsets.zero,
          color: AppColors.positiveColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCartInfoContainerWidget(context),
                _buildViewCartButtonWidget(context)
              ])));
}
