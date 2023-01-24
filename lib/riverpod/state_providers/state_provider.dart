import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:ncart_eats/riverpod/service_providers/screen_services.dart';

final timerIndicatorProvider =
    StateNotifierProvider<TimerIndicatorService, int>(
        (ref) => TimerIndicatorService());

final loaderIndicatorProvider =
    StateNotifierProvider<LoaderIndicatorService, bool>(
        (ref) => LoaderIndicatorService());

final currentUserProvider =
    StateNotifierProvider<CurrentUserService, CurrentUser?>(
        (ref) => CurrentUserService());

final currentLocationProvider =
    StateNotifierProvider<CurrentLocationService, CurrentLocation?>(
        (ref) => CurrentLocationService());
