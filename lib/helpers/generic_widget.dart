import 'package:flutter/material.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class GenericWidget {
  static Widget buildCircularProgressIndicator(bool enabled) => enabled
      ? const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 4, color: AppColors.themeColor)))
      : Container();
}
