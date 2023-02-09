import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class GenericWidget {
  static Widget buildCircularProgressIndicator(bool enabled) => enabled
      ? Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 4, color: AppColors.primaryColor)))
      : Container();

  static Widget buildCachedNetworkImage(
          String imageURL, double? borderRadius) =>
      imageURL.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageURL,
              imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius ?? 0),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill))),
              placeholder: (context, url) =>
                  buildCircularProgressIndicator(true))
          : Container();

  static Widget buildDotSeparatorWidget(Color dotColor) => Padding(
      padding: const EdgeInsets.only(left: 6, right: 5),
      child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)));
}
