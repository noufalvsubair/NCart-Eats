import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';

class TimerIndicatorService extends StateNotifier<int> {
  TimerIndicatorService() : super(60);

  void setTime(int time) => state = time;
}

class LoaderIndicatorService extends StateNotifier<bool> {
  LoaderIndicatorService() : super(false);

  void show() => state = true;

  void hide() => state = false;
}

class CurrentUserService extends StateNotifier<CurrentUser?> {
  CurrentUserService() : super(null);

  void setCurrentUser(CurrentUser? currentUser) => state = currentUser;
}

class CurrentLocationService extends StateNotifier<CurrentLocation?> {
  CurrentLocationService() : super(null);

  void setCurrentLocation(CurrentLocation? location) => state = location;
}
