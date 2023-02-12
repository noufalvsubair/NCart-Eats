import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/widget/app_bottom_dropdown.dart';

class AppShopInfoCard extends StatelessWidget {
  final Shop shopInfo;

  const AppShopInfoCard({Key? key, required this.shopInfo}) : super(key: key);

  Widget _buildShopClosedContainer(BuildContext context) => shopInfo.hasClosed!
      ? Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 15),
          child: Text(
              S.of(context).shopClosedDescription(shopInfo.openingTime!),
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                  fontSize: 15)))
      : Container();

  Widget _buildShopNameContainerWidget() => Padding(
      padding: const EdgeInsets.only(left: 10, right: 15, top: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(shopInfo.name!,
                    style: GoogleFonts.raleway(
                        color: AppColors.textHighestEmphasisColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18))),
            Row(children: [
              _buildShareButtonWidget(),
              _buildFavouriteButtonWidget()
            ])
          ]));

  Widget _buildShareButtonWidget() => InkWell(
      onTap: () {},
      child: Icon(Icons.share,
          size: 18, color: AppColors.backgroundOverlayDarkColor));

  Widget _buildFavouriteButtonWidget() => Padding(
      padding: const EdgeInsets.only(left: 15),
      child: InkWell(
          onTap: () {},
          child: SvgPicture.asset(AppIcons.favouriteLight,
              width: 25, height: 25)));

  Widget _buildRatingAndConstForTwoWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.stars, size: 20, color: AppColors.positiveColor),
            Padding(
                padding: const EdgeInsets.only(left: 5, right: 2),
                child: Text(
                    shopInfo.ratingAndReviewCount(S.of(context).ratings),
                    style: GoogleFonts.robotoFlex(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHighestEmphasisColor))),
            _buildShopRatingInfoToolTipWidget(context),
            GenericWidget.buildDotSeparatorWidget(
                AppColors.backgroundOverlayDarkColor),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                    S.of(context).costForTwo(shopInfo.costForTwo!.toInt()),
                    style: GoogleFonts.robotoFlex(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHighestEmphasisColor)))
          ]));

  Widget _buildShopRatingInfoToolTipWidget(BuildContext context) => Tooltip(
      message: S.of(context).ratingDescription,
      triggerMode: TooltipTriggerMode.tap,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 0),
      showDuration: const Duration(seconds: 5),
      decoration: BoxDecoration(
        color: AppColors.textHighestEmphasisColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      verticalOffset: 10,
      textStyle: GoogleFonts.raleway(
          fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
      child: Icon(Icons.info_outline_rounded,
          size: 14, color: AppColors.backgroundOverlayDarkColor));

  Widget _buildCuisinesTextWidget() => Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
      child: Text(
          shopInfo.cuisines!.length > 2
              ? shopInfo.cuisines!.sublist(0, 2).join(', ')
              : shopInfo.cuisines!.join(", "),
          style: GoogleFonts.raleway(
              fontWeight: FontWeight.w400,
              color: AppColors.textHighestEmphasisColor,
              fontSize: 13)));

  Widget _buildCommonLineSeparatorWidget() => Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 15,
      ),
      child: Divider(color: AppColors.backgroundTertiaryColor, height: 1));

  Widget _buildOutletAndDeliveryTimeContainerWidget(BuildContext context) =>
      Consumer(builder: (_, ref, __) {
        String? currentLocationType = Utilities.getCurrentLocationType(
            ref.watch(currentLocationProvider)?.type ?? "", context);

        return Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBottomDropdown(
                        title: S.of(context).outlet,
                        value: shopInfo.location!,
                        valuePadding: 20,
                        onTapped: () {}),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: AppBottomDropdown(
                            title: shopInfo.timeDuration,
                            value:
                                S.of(context).deliveryTo(currentLocationType),
                            onTapped: () {}))
                  ]),
              Positioned(
                  top: 10,
                  left: 2,
                  child: Container(
                      height: 20,
                      color: AppColors.textLowEmphasisColor,
                      width: 1))
            ]));
      });

  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.all(15),
      elevation: 0,
      color: AppColors.backgroundPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShopClosedContainer(context),
            if (shopInfo.hasClosed!) _buildCommonLineSeparatorWidget(),
            _buildShopNameContainerWidget(),
            _buildRatingAndConstForTwoWidget(context),
            _buildCuisinesTextWidget(),
            _buildCommonLineSeparatorWidget(),
            _buildOutletAndDeliveryTimeContainerWidget(context),
          ]));
}
