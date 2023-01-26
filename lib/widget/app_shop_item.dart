import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/location.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';

class AppShopItem extends StatelessWidget {
  final Shop shop;
  final VoidCallback onItemTapped;
  final VoidCallback onFavouriteIconTapped;

  const AppShopItem(
      {Key? key,
      required this.shop,
      required this.onItemTapped,
      required this.onFavouriteIconTapped})
      : super(key: key);

  String getRatingAndReview() {
    String embeddedString = "";
    if (shop.rating! > 0) {
      embeddedString = "${shop.rating}";
    }

    if (shop.reviewCount! > 0) {
      embeddedString += " (${Utilities.viewCountFormatter(shop.reviewCount!)})";
    }

    return embeddedString;
  }

  Widget _buildShopImageWidget() => SizedBox(
      width: 110,
      height: 125,
      child: GenericWidget.buildCachedNetworkImage(shop.image!, 15));

  Widget _buildDotSeparatorWidget(Color dotColor) => Padding(
      padding: const EdgeInsets.only(left: 6, right: 5),
      child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)));

  Widget _buildRatingAndTimeViewWidget() => Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.stars, size: 20, color: AppColors.positiveColor),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(getRatingAndReview(),
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHighestEmphasisColor))),
            if (shop.deliveryTime != null && shop.deliveryTime!.isNotEmpty)
              _buildDotSeparatorWidget(AppColors.textHighestEmphasisColor),
            if (shop.deliveryTime != null && shop.deliveryTime!.isNotEmpty)
              Text(shop.deliveryTime!,
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHighestEmphasisColor))
          ]));

  Widget _buildLocationAndDistanceWidget() =>
      Consumer(builder: (_, WidgetRef ref, __) {
        CurrentLocation? currentLocation = ref.watch(currentLocationProvider);
        String distance = (shop.latitude != null &&
                shop.latitude!.isNotEmpty &&
                shop.longitude != null &&
                shop.longitude!.isNotEmpty)
            ? Locations.calculateDistanceByLatLong(
                currentLocation?.latitude,
                currentLocation?.longitude,
                double.parse(shop.latitude!),
                double.parse(shop.longitude!))
            : "";

        return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(shop.location!,
                      style: GoogleFonts.encodeSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMedEmphasisColor)),
                  if (distance.isNotEmpty)
                    _buildDotSeparatorWidget(AppColors.textMedEmphasisColor),
                  if (distance.isNotEmpty)
                    Text(distance,
                        style: GoogleFonts.encodeSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMedEmphasisColor)),
                ]));
      });

  Widget _buildFreeDeliveryViewWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining_rounded,
                size: 15, color: AppColors.textLowEmphasisColor),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(S.of(context).freeDelivery,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLowEmphasisColor)))
          ]));

  Widget _buildShopInfoViewWidget(BuildContext context) => Flexible(
      flex: 1,
      child: Container(
          margin: const EdgeInsets.only(left: 15, top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop.name!,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHighestEmphasisColor)),
                _buildRatingAndTimeViewWidget(),
                if (shop.cuisines != null && shop.cuisines!.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(shop.cuisines!.join(", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.encodeSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMedEmphasisColor))),
                _buildLocationAndDistanceWidget(),
                if (shop.hasFreeDelivery!) _buildFreeDeliveryViewWidget(context)
              ])));

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShopImageWidget(),
              _buildShopInfoViewWidget(context)
            ]));
  }
}
