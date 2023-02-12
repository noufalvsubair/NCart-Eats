import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/location.dart';
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

  Widget _buildShopImageWidget(BuildContext context) => Stack(children: [
        Container(
            width: 110,
            height: 125,
            foregroundDecoration: BoxDecoration(
                color: shop.hasClosed! ? Colors.black : Colors.transparent,
                backgroundBlendMode: BlendMode.saturation,
                borderRadius: BorderRadius.circular(15)),
            child: GenericWidget.buildCachedNetworkImage(shop.image!, 15)),
        if (shop.hasClosed!)
          Positioned(
              bottom: 5,
              left: 5,
              child: Text(S.of(context).closed.toUpperCase(),
                  style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.backgroundPrimaryColor)))
      ]);

  Widget _buildRatingAndTimeViewWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.stars, size: 20, color: AppColors.positiveColor),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(shop.ratingAndReviewCount(''),
                    style: GoogleFonts.robotoFlex(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHighestEmphasisColor))),
            if (shop.deliveryTime != null)
              GenericWidget.buildDotSeparatorWidget(
                  AppColors.textHighestEmphasisColor),
            if (shop.deliveryTime != null)
              Text(shop.timeDuration,
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHighestEmphasisColor))
          ]));

  Widget _buildLocationAndDistanceWidget() =>
      Consumer(builder: (_, WidgetRef ref, __) {
        CurrentLocation? currentLocation = ref.watch(currentLocationProvider);
        String distance = (shop.latitude != null && shop.longitude != null)
            ? Locations.calculateDistanceByLatLong(currentLocation?.latitude,
                currentLocation?.longitude, shop.latitude!, shop.longitude!)
            : "";

        return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(shop.location!,
                      style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textHighEmphasisColor)),
                  if (distance.isNotEmpty)
                    GenericWidget.buildDotSeparatorWidget(
                        AppColors.textMedEmphasisColor),
                  if (distance.isNotEmpty)
                    Text(distance,
                        style: GoogleFonts.robotoFlex(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
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
                size: 15,
                color: AppColors.textLowEmphasisColor.withOpacity(0.6)),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(S.of(context).freeDelivery,
                    style: GoogleFonts.robotoFlex(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMedEmphasisColor)))
          ]));

  Widget _buildTomorrowOpenTimeTextWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(S.of(context).openMessage(shop.openingTime),
          style: GoogleFonts.robotoFlex(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMedEmphasisColor)));

  Widget _buildShopInfoViewWidget(BuildContext context) => Flexible(
      flex: 1,
      child: Container(
          margin: const EdgeInsets.only(left: 15, top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop.name!,
                    style: GoogleFonts.raleway(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHighestEmphasisColor)),
                _buildRatingAndTimeViewWidget(context),
                if (shop.cuisines != null && shop.cuisines!.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(shop.cuisines!.join(", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textHighEmphasisColor))),
                _buildLocationAndDistanceWidget(),
                if (shop.hasFreeDelivery! && !shop.hasClosed!)
                  _buildFreeDeliveryViewWidget(context),
                if (shop.hasClosed!) _buildTomorrowOpenTimeTextWidget(context)
              ])));

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onItemTapped,
        child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShopImageWidget(context),
                  _buildShopInfoViewWidget(context)
                ])));
  }
}
