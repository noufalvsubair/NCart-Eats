import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ncart_eats/helpers/permission.dart';
import 'package:ncart_eats/model/current_location.dart';

class Locations {
  static Future<CurrentLocation> getCurrentLocation() async {
    bool serviceEnabled = await Permission.hasLocationPermissionEnabled();
    if (!serviceEnabled) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(LocationPermission.denied);
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(LocationPermission.deniedForever);
      }
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    List<Placemark> locations = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    String address = createAddressFromPlaceMar(locations.first);

    return CurrentLocation(
        name: address,
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);
  }

  static String createAddressFromPlaceMar(Placemark location) {
    String address = '';
    address += appendComaToString(location.street);
    address += appendComaToString(location.name);
    address += appendComaToString(location.thoroughfare);
    address += appendComaToString(location.locality);
    address += appendComaToString(location.administrativeArea);
    address += appendComaToString(location.country);
    address += location.postalCode!;

    return address;
  }

  static String appendComaToString(String? text) =>
      text!.isNotEmpty ? "$text, " : "";
}
