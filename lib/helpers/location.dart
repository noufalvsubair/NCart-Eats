import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/helpers/permission.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';

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
    CurrentLocation currentLocation = await getLocationFromLatLng(
        currentPosition.latitude, currentPosition.longitude);

    return currentLocation;
  }

  static Future<CurrentLocation> getLocationFromLatLng(
      double latitude, double longitude) async {
    List<Placemark> locations =
        await placemarkFromCoordinates(latitude, longitude);
    String address = createAddressFromPlaceMar(locations.first);

    return CurrentLocation(
        type: LocationType.other.toString(),
        name: address,
        latitude: latitude,
        longitude: longitude);
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

  static String calculateDistanceByLatLong(
      double? startLocationLat,
      double? startLocationLong,
      double endLocationLat,
      double endLocationLong) {
    double distance = Geolocator.distanceBetween(
        startLocationLat!, startLocationLong!, endLocationLat, endLocationLong);

    return "${(distance / 1000).toStringAsFixed(1)} km";
  }
}
