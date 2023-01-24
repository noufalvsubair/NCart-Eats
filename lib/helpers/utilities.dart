import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/generated/l10n.dart';

class Utilities {
  static showToastBar(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white);
  }

  static showToastBarLogin(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white);
  }

  static showToastBarLong(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white);
  }

  static navigateTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  static navigateWithReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget));
  }

  static navigateAndClearAll(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
        (Route<dynamic> route) => false);
  }

  static IconData getCurrentLocationTypeIcon(String locationType) {
    if (locationType == LocationType.home.toString()) {
      return Icons.home_filled;
    } else if (locationType == LocationType.work.toString()) {
      return Icons.work_outlined;
    } else {
      return Icons.location_on_rounded;
    }
  }

  static String getCurrentLocationType(
      String locationType, BuildContext context) {
    if (locationType == LocationType.home.toString()) {
      return S.of(context).home;
    } else if (locationType == LocationType.work.toString()) {
      return S.of(context).work;
    } else {
      return S.of(context).other;
    }
  }
}
