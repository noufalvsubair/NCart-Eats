import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/model/dish/dish.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/widget/app_counter_button.dart';

class AppDishItem extends StatelessWidget {
  final Dish foodInfo;
  final bool hasShopClosed;

  const AppDishItem({
    Key? key,
    required this.foodInfo,
    required this.hasShopClosed,
  }) : super(key: key);

  Widget _buildBestSellerContainerWidget(BuildContext context) => Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.bestSeller, width: 10, height: 10),
            Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(S.of(context).bestSeller,
                    style: GoogleFonts.openSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor)))
          ]));

  Widget _buildFoodNameTextWidget() => Padding(
      padding: const EdgeInsets.only(top: 5, right: 10),
      child: Text(foodInfo.name!,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textHighestEmphasisColor)));

  Widget _buildFoodPriceTextWidget() => Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: Text("₹${foodInfo.price!}",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: AppColors.textHighestEmphasisColor)));

  Widget _buildFoodRatingBarWidget() => Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBarIndicator(
                unratedColor: AppColors.backgroundTertiaryColor,
                itemCount: 5,
                rating: foodInfo.rating!,
                itemSize: 15,
                itemBuilder: (BuildContext context, _) =>
                    Icon(Icons.star, color: AppColors.activeRatingBarColor)),
            Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text("${foodInfo.rating!}",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.activeRatingBarColor))),
            Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text("(${foodInfo.reviewCount!.toInt()})",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.textMedEmphasisColor)))
          ]));

  Widget _buildFoodDescriptionTextWidget() => Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: Text(foodInfo.description!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.textMedEmphasisColor)));

  Widget _buildFoodInfoContainerWidget(BuildContext context) => Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            if (foodInfo.type != null && foodInfo.type!.isNotEmpty)
              Row(children: [
                GenericWidget.buildDishTypeContainerWidget(foodInfo.type == 'veg'),
                if (foodInfo.isBestSeller!)
                  _buildBestSellerContainerWidget(context)
              ]),
            _buildFoodNameTextWidget(),
            _buildFoodPriceTextWidget(),
            if (foodInfo.rating != null && foodInfo.rating! > 0)
              _buildFoodRatingBarWidget(),
            if (foodInfo.description != null &&
                foodInfo.description!.isNotEmpty)
              _buildFoodDescriptionTextWidget()
          ]));

  Widget _buildFoodImageWidget(BuildContext context) => SizedBox(
      height: 122,
      child: Stack(children: [
        Container(
            width: 110,
            height: 110,
            foregroundDecoration: BoxDecoration(
                color: hasShopClosed ? Colors.black : Colors.transparent,
                backgroundBlendMode: BlendMode.saturation,
                borderRadius: BorderRadius.circular(15)),
            child: GenericWidget.buildCachedNetworkImage(foodInfo.image!, 15)),
        if (!hasShopClosed) _buildAddButtonWidget(context)
      ]));

  Widget _buildAddButtonWidget(BuildContext context) => Positioned(
      bottom: 0,
      left: 10,
      child: AppCounterButton(
          label: S.of(context).add,
          onAddButtonTapped: () {},
          onUpdateCount: (double value) => {}));

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFoodInfoContainerWidget(context),
            if (foodInfo.image != null && foodInfo.image!.isNotEmpty)
              _buildFoodImageWidget(context)
          ]));
}
