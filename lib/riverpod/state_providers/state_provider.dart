import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:ncart_eats/model/offer/offer.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/riverpod/service_providers/offer_service.dart';
import 'package:ncart_eats/riverpod/service_providers/screen_services.dart';
import 'package:ncart_eats/riverpod/service_providers/shop_service.dart';

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

final offerProvider =
    StateNotifierProvider<OfferService, List<Offer>>((ref) => OfferService());

final shopProvider =
    StateNotifierProvider<ShopService, List<Shop>>((ref) => ShopService());
