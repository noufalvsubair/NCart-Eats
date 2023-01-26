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
      CachedNetworkImage(
          imageUrl: imageURL,
          imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill))),
          placeholder: (context, url) => buildCircularProgressIndicator(true));
}
