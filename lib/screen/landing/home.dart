import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_styles.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late bool locationHeaderEnabled = true;

  List<Widget> _buildExpandableAppBarWidget() => <Widget>[
        SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 130,
            floating: true,
            pinned: true,
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.account_circle,
                          color: Colors.blueGrey, size: 40)))
            ],
            flexibleSpace:
                FlexibleSpaceBar(background: _buildAppBarHeaderViewWidget()),
            bottom: _buildSearchBarWidget())
      ];

  Widget? _buildAppBarHeaderViewWidget() => locationHeaderEnabled
      ? Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + 12,
              right: 8,
              left: 12),
          child: _buildHeaderLocationViewWidget())
      : Container();

  Widget _buildHeaderLocationViewWidget() {
    CurrentLocation? currentLocation = ref.watch(currentLocationProvider);

    return InkWell(
        onTap: () {},
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationTypeViewWidget(currentLocation!.type),
              Padding(
                  padding: const EdgeInsets.only(left: 5, top: 1),
                  child: Text(currentLocation.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMedEmphasisColor)))
            ]));
  }

  Widget _buildLocationTypeViewWidget(String? type) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Utilities.getCurrentLocationTypeIcon(type!),
                size: 20, color: AppColors.primaryColor),
            Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(Utilities.getCurrentLocationType(type, context),
                    style: GoogleFonts.encodeSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHighestEmphasisColor))),
            Icon(Icons.arrow_drop_down,
                size: 22, color: AppColors.backgroundOverlayDarkColor)
          ]);

  PreferredSize _buildSearchBarWidget() => PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: Container(
          width: MediaQuery.of(context).size.width - 30,
          height: 45,
          margin:
              const EdgeInsets.only(left: 12, right: 10, top: 15, bottom: 15),
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.0)),
          child: TextField(
              cursorColor: AppColors.primaryColor,
              decoration: AppStyles.fieldDecorationWithIcon(
                  context,
                  S.of(context).globalSearch,
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(Icons.search_rounded,
                          size: 25, color: AppColors.textLowEmphasisColor))))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) =>
                    _buildExpandableAppBarWidget(),
            body: const Center(child: Text('Sample Text'))));
  }
}
