import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/location.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_location.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/screen/location/select_map_location.dart';
import 'package:ncart_eats/widget/app_button.dart';

class SetLocation extends ConsumerStatefulWidget {
  const SetLocation({Key? key}) : super(key: key);

  @override
  ConsumerState<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends ConsumerState<SetLocation> {
  void _onUseCurrentLocationButtonTapped() async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      CurrentLocation currentLocation = await Locations.getCurrentLocation();
      ref.read(loaderIndicatorProvider.notifier).hide();
    } catch (error) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      Utilities.showToastBar(S.of(context).locationPermissionError, context);
    }
  }

  void _onSetFromMapButtonTapped() =>
      Utilities.navigateTo(context, const SelectMapLocation());

  PreferredSize _buildAppBarWidget() => PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: AppColors.normalTextColor),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(S.of(context).setLocation,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.normalTextColor))));

  Widget _buildCircularIndicatorWidget(bool enabled) => enabled
      ? const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 4, color: AppColors.themeColor)))
      : Container();

  Widget _buildEmptyIconWidget() =>
      Center(child: Image.asset(AppIcons.emptyAddress));

  Widget _buildEmptyMessageTextWidget() => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 25),
      child: Text(S.of(context).emptyAddress,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.transparentTextColor)));

  Widget _buildUseCurrentLocationButtonWidget(bool enabled) => AppButton(
      label: S.of(context).useCurrentLocation,
      type: ButtonType.primary.toString(),
      icon: Icons.my_location,
      onTapped: () => enabled ? null : _onUseCurrentLocationButtonTapped());

  Widget _buildSetFromMapButtonWidget(bool enabled) => AppButton(
      label: S.of(context).setFromMap,
      type: ButtonType.tertiary.toString(),
      icon: Icons.map_sharp,
      onTapped: () => enabled ? null : _onSetFromMapButtonTapped());

  @override
  Widget build(BuildContext context) {
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBarWidget(),
        body: Stack(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildEmptyIconWidget(),
                _buildEmptyMessageTextWidget(),
                _buildUseCurrentLocationButtonWidget(loaderEnabled),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: _buildSetFromMapButtonWidget(loaderEnabled))
              ]),
          _buildCircularIndicatorWidget(loaderEnabled)
        ]));
  }
}
