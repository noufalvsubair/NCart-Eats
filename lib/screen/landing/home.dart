import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_location/current_location.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_styles.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/riverpod/states/dashboard_state.dart';
import 'package:ncart_eats/screen/location/set_location.dart';
import 'package:ncart_eats/screen/menu/profile.dart';
import 'package:ncart_eats/widget/app_image_carousel.dart';
import 'package:ncart_eats/widget/app_shop_item.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  DashboardState dashboardInfo = DashboardState.initial();

  @override
  void initState() {
    Future.delayed(Duration.zero, () => _fetchDashboardInfo());

    super.initState();
  }

  void _fetchDashboardInfo() async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      await ref.read(dashboardInfoProvider.notifier).fetchDashboardInfo();
      ref.read(loaderIndicatorProvider.notifier).hide();
    } catch (err) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      Utilities.showToastBar(err.toString(), context);
    }
  }

  List<Widget> _buildExpandableAppBarWidget() => <Widget>[
        SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: AppColors.backgroundPrimaryColor,
            expandedHeight: 130,
            floating: true,
            pinned: true,
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: InkWell(
                      onTap: () =>
                          Utilities.navigateTo(context, const Profile()),
                      child: Icon(Icons.account_circle,
                          color: AppColors.textHighEmphasisColor, size: 40)))
            ],
            flexibleSpace:
                FlexibleSpaceBar(background: _buildAppBarHeaderViewWidget()),
            bottom: _buildSearchBarWidget())
      ];

  Widget? _buildAppBarHeaderViewWidget() => Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 12, right: 8, left: 12),
      child: _buildHeaderLocationViewWidget());

  Widget _buildHeaderLocationViewWidget() {
    CurrentLocation? currentLocation = ref.watch(currentLocationProvider);

    return InkWell(
        onTap: () => Utilities.navigateTo(context, const SetLocation()),
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

  Widget _buildCircularProgressWidget() {
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return GenericWidget.buildCircularProgressIndicator(loaderEnabled);
  }

  Widget _buildOfferCarouselWidget() => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: AppImageCarousel(offers: dashboardInfo.offers!));

  Widget _buildShopTitleTextWidget(String title) => Padding(
      padding: const EdgeInsets.only(left: 15, top: 30),
      child: Text(title,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textHighestEmphasisColor)));

  Widget _buildOpenedShopListWidget(List<Shop> openedShops) {
    return ListView.builder(
        itemCount: openedShops.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => AppShopItem(
            shop: openedShops[index],
            onItemTapped: () {},
            onFavouriteIconTapped: () {}));
  }

  @override
  Widget build(BuildContext context) {
    dashboardInfo = ref.read(dashboardInfoProvider);

    return Scaffold(
        backgroundColor: AppColors.backgroundPrimaryColor,
        body: Stack(children: [
          NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) =>
                      _buildExpandableAppBarWidget(),
              body: ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if (dashboardInfo.offers!.isNotEmpty)
                      _buildOfferCarouselWidget(),
                    if (dashboardInfo.openedShops!.isNotEmpty)
                      _buildShopTitleTextWidget(
                          S.of(context).restaurantsToExplore),
                    if (dashboardInfo.openedShops!.isNotEmpty)
                      _buildOpenedShopListWidget(dashboardInfo.openedShops!),
                    if (dashboardInfo.closedShops!.isNotEmpty)
                      _buildShopTitleTextWidget(
                          S.of(context).temporarilyClosed),
                    if (dashboardInfo.closedShops!.isNotEmpty)
                      _buildOpenedShopListWidget(dashboardInfo.closedShops!)
                  ])),
          _buildCircularProgressWidget()
        ]));
  }
}
