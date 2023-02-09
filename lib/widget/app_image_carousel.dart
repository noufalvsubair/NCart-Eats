import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/model/offer/offer.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class AppImageCarousel extends StatefulWidget {
  final List<Offer> offers;

  const AppImageCarousel({Key? key, required this.offers}) : super(key: key);

  @override
  State<AppImageCarousel> createState() => _AppImageCarouselState();
}

class _AppImageCarouselState extends State<AppImageCarousel> {
  late int selectedIndex = 0;

  Widget _buildPageIndicatorDotWidget() => Container(
      width: 7,
      height: 7,
      margin: const EdgeInsets.only(right: 10),
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.grey));

  Widget _buildSelectedIndicatorWidget() => Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.textHighEmphasisColor),
      child: Text("${selectedIndex + 1}/${widget.offers.length}",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: AppColors.backgroundPrimaryColor)));

  Widget _buildPageIndicatorWidget() => Container(
      margin: const EdgeInsets.only(top: 18),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.offers.map((offer) {
            int index = widget.offers.indexOf(offer);

            return index == selectedIndex
                ? _buildSelectedIndicatorWidget()
                : _buildPageIndicatorDotWidget();
          }).toList()));

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      CarouselSlider.builder(
          itemCount: widget.offers.length,
          itemBuilder: (BuildContext context, int itemIndex, int _) =>
              Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(left: 16),
                  child: GenericWidget.buildCachedNetworkImage(
                      widget.offers[itemIndex].image!, 15)),
          options: CarouselOptions(
              onPageChanged: (int index, CarouselPageChangedReason _) =>
                  setState(() => selectedIndex = index),
              height: 190,
              enableInfiniteScroll: widget.offers.length > 1,
              padEnds: false)),
      _buildPageIndicatorWidget()
    ]);
  }
}
