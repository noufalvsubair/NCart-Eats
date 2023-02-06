import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/shared_preference.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/screen/authentication/login.dart';
import 'package:ncart_eats/screen/landing/home.dart';
import 'package:ncart_eats/screen/location/set_location.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => _navigateTo((String key) {
              if (key == LandingScreen.home.toString()) {
                Utilities.navigateAndClearAll(context, const Home());
              } else if (key == LandingScreen.setLocation.toString()) {
                Utilities.navigateAndClearAll(context, const SetLocation());
              } else {
                Utilities.navigateAndClearAll(context, const Login());
              }
            }));

    super.initState();
  }

  void _navigateTo(ValueChanged<String> onSuccess) async {
    ref.read(loaderIndicatorProvider.notifier).show();
    CurrentUser? currentUser = await SharedPreferenceHelper.shared.getUser();
    CurrentLocation? currentLocation =
        await SharedPreferenceHelper.shared.getLocation();
    ref.read(loaderIndicatorProvider.notifier).hide();
    ref.read(currentUserProvider.notifier).setCurrentUser(currentUser);
    ref
        .read(currentLocationProvider.notifier)
        .setCurrentLocation(currentLocation);

    if (currentUser != null && currentLocation != null) {
      onSuccess(LandingScreen.home.toString());
    } else if (currentUser != null && currentLocation == null) {
      onSuccess(LandingScreen.setLocation.toString());
    } else {
      onSuccess(LandingScreen.login.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Center(child: Image.asset(AppIcons.logo)),
          GenericWidget.buildCircularProgressIndicator(loaderEnabled)
        ]));
  }
}
