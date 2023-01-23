import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/riverpod/service_providers/screen_services.dart';

final timerIndicatorProvider =
    StateNotifierProvider<TimerIndicatorService, int>(
        (ref) => TimerIndicatorService());

final loaderIndicatorProvider =
    StateNotifierProvider<LoaderIndicatorService, bool>(
        (ref) => LoaderIndicatorService());
