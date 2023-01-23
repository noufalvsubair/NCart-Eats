import 'package:geolocator/geolocator.dart';

class Permission {
  static Future<bool> hasLocationPermissionEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission locationPermission = await Geolocator.checkPermission();

    return serviceEnabled &&
        (locationPermission == LocationPermission.always ||
            locationPermission == LocationPermission.whileInUse);
  }
}
