import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/model/cart/cart.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:ncart_eats/model/dish/dish.dart';
import 'package:ncart_eats/riverpod/service_providers/cart_service.dart';
import 'package:ncart_eats/riverpod/service_providers/dashboard_service.dart';
import 'package:ncart_eats/riverpod/service_providers/dish_service.dart';
import 'package:ncart_eats/riverpod/service_providers/screen_services.dart';
import 'package:ncart_eats/riverpod/states/dashboard_state.dart';

final timerIndicatorProvider =
    StateNotifierProvider.autoDispose<TimerIndicatorService, int>(
        (ref) => TimerIndicatorService());

final loaderIndicatorProvider =
    StateNotifierProvider.autoDispose<LoaderIndicatorService, bool>(
        (ref) => LoaderIndicatorService());

final currentUserProvider =
    StateNotifierProvider<CurrentUserService, CurrentUser?>(
        (ref) => CurrentUserService());

final currentLocationProvider =
    StateNotifierProvider<CurrentLocationService, CurrentLocation?>(
        (ref) => CurrentLocationService());

final dashboardInfoProvider =
    StateNotifierProvider<DashboardService, DashboardState>(
        (ref) => DashboardService());

final dishInfoProvider =
    StateNotifierProvider.autoDispose<DishService, List<Dish>>(
        (ref) => DishService());

final scrollInfoProvider =
    StateNotifierProvider.autoDispose<ScrollInfoService, double>(
        (ref) => ScrollInfoService());

final cartInfoProvider =
    StateNotifierProvider.autoDispose<CartInfoService, List<Cart>>(
        (ref) => CartInfoService());
