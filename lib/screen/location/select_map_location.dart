import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/location.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_location.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/widget/app_button.dart';

class SelectMapLocation extends ConsumerStatefulWidget {
  const SelectMapLocation({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectMapLocation> createState() => _SelectMapLocationState();
}

class _SelectMapLocationState extends ConsumerState<SelectMapLocation> {
  late Completer<GoogleMapController> mapController;
  CurrentLocation? selectedLocation;
  CameraPosition? mapCameraPosition;

  @override
  void initState() {
    mapController = Completer<GoogleMapController>();
    selectedLocation = CurrentLocation();

    Future.delayed(
        const Duration(seconds: 0), () => _fetchCurrentLocationInfo());

    super.initState();
  }

  void _fetchCurrentLocationInfo() async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      CurrentLocation currentLocation = await Locations.getCurrentLocation();
      _setMapLocation(currentLocation);
      setState(() => selectedLocation = currentLocation);
    } catch (error) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      Utilities.showToastBar(S.of(context).locationPermissionError, context);
    }
  }

  void _setMapLocation(CurrentLocation currentLocation) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        tilt: 40.440717697143555,
        zoom: 19.0)));

    ref.read(loaderIndicatorProvider.notifier).hide();
  }

  void _fetchLocationFromLatLng() async {
    if (mapCameraPosition != null &&
        selectedLocation != null &&
        selectedLocation!.latitude != mapCameraPosition!.target.latitude) {
      try {
        ref.read(loaderIndicatorProvider.notifier).show();
        CurrentLocation location = await Locations.getLocationFromLatLng(
            mapCameraPosition!.target.latitude,
            mapCameraPosition!.target.longitude);
        _setMapLocation(location);
        setState(() => selectedLocation = location);
      } catch (error) {
        ref.read(loaderIndicatorProvider.notifier).hide();
        Utilities.showToastBar(S.of(context).locationPermissionError, context);
      }
    }
  }

  Widget _buildLocationNameWidget() => Positioned(
      left: 20,
      top: MediaQuery.of(context).viewPadding.top + 10,
      child: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 10, right: 12),
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: AppColors.shadowColor,
                    offset: Offset(0.0, 0.5), //(x,y)
                    blurRadius: 3.0)
              ]),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_sharp,
                    color: AppColors.themeColor),
                Flexible(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(selectedLocation!.name!,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.openSans(
                                color: AppColors.normalTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500))))
              ])));

  Widget _buildCircularIndicatorWidget(bool enabled) => enabled
      ? const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 4, color: AppColors.themeColor)))
      : Container();

  Widget _buildGoogleMapWidget() => GoogleMap(
      initialCameraPosition: const CameraPosition(
          target: LatLng(9.981636, 76.299881), zoom: 14.4746),
      zoomControlsEnabled: false,
      compassEnabled: false,
      onCameraMove: (CameraPosition cameraPosition) =>
          setState(() => mapCameraPosition = cameraPosition),
      onCameraIdle: () => _fetchLocationFromLatLng(),
      onMapCreated: (GoogleMapController controller) =>
          mapController.complete(controller));

  Widget _buildGoogleMapMarkerWidget() =>
      Center(child: Image.asset(AppIcons.marker, width: 40, height: 40));

  Widget _buildCurrentLocationButtonWidget() => Positioned(
      right: 20,
      bottom: 75,
      child: InkWell(
          onTap: _fetchCurrentLocationInfo,
          child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadowColor,
                        offset: Offset(0.0, 1), //(x,y)
                        blurRadius: 5.0)
                  ]),
              child: const Icon(Icons.my_location,
                  size: 25, color: AppColors.themeColor))));

  Widget _buildPickLocationButtonWidget() => Positioned(
      bottom: 10,
      left: 20,
      child: AppButton(
          label: S.of(context).pickLocation,
          type: ButtonType.primary.toString(),
          onTapped: () {}));

  @override
  Widget build(BuildContext context) {
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          _buildGoogleMapWidget(),
          if (selectedLocation!.name != null) _buildLocationNameWidget(),
          _buildCircularIndicatorWidget(loaderEnabled),
          if (!loaderEnabled) _buildGoogleMapMarkerWidget(),
          if (!loaderEnabled) _buildCurrentLocationButtonWidget(),
          if (!loaderEnabled) _buildPickLocationButtonWidget()
        ]));
  }
}
