import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerIndicatorService extends StateNotifier<int> {
  TimerIndicatorService() : super(60);

  void setTime(int time) => state = time;
}

class LoaderIndicatorService extends StateNotifier<bool> {
  LoaderIndicatorService() : super(false);

  void show() => state = true;

  void hide() => state = false;
}
