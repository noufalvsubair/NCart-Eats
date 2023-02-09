import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/shared_preference.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/screen/authentication/login.dart';
import 'package:ncart_eats/widget/app_menu_item.dart';
import 'package:ncart_eats/widget/app_vertical_label_icon_card.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  CurrentUser? currentUser;

  void _onLogOutTapped(VoidCallback onSuccess) async {
    ref.read(loaderIndicatorProvider.notifier).show();
    await SharedPreferenceHelper.shared.clearPreference();
    await FirebaseAuth.instance.signOut();
    onSuccess();
    ref.read(loaderIndicatorProvider.notifier).hide();
  }

  PreferredSize _buildAppBarWidget() => PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.backgroundTertiaryColor,
              statusBarColor: AppColors.backgroundTertiaryColor,
              statusBarIconBrightness: Brightness.dark),
          elevation: 0.0,
          iconTheme: IconThemeData(color: AppColors.textHighestEmphasisColor),
          backgroundColor: AppColors.backgroundTertiaryColor));

  Widget _buildUserNameAndMobileWidget() => Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentUser?.firstName ?? '',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.textHighestEmphasisColor)),
            Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(currentUser!.mobile ?? "",
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textHighestEmphasisColor)))
          ]));

  Widget _buildUserImageWidget() => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: AppColors.backgroundTertiaryColor, width: 4)),
        padding: const EdgeInsets.all(2),
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.blueGrey),
          child: Text(
              '${currentUser?.firstName![0]}${currentUser?.lastName![0]}',
              style: GoogleFonts.encodeSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  color: AppColors.backgroundPrimaryColor)),
        ),
      );

  Widget _buildUserInfoViewWidget() => SizedBox(
      height: 120,
      child: Card(
          margin: const EdgeInsets.only(left: 10, right: 10),
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: AppColors.backgroundTertiaryColor,
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 25),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildUserImageWidget(),
                    _buildUserNameAndMobileWidget()
                  ]))));

  Widget _buildHorizontalMenuWidget() => Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppVerticalLabelIconCard(
                label: S.of(context).payment,
                svgIcon: AppIcons.creditCard,
                onTapped: () {}),
            AppVerticalLabelIconCard(
                label: S.of(context).refund,
                svgIcon: AppIcons.refund,
                onTapped: () {}),
            AppVerticalLabelIconCard(
                label: S.of(context).settings,
                svgIcon: AppIcons.setting,
                onTapped: () {})
          ]));

  Widget _buildRatingStarWidget() => Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.backgroundTertiaryColor),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${currentUser?.rating! ?? 0}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: AppColors.textHighestEmphasisColor)),
            const Icon(Icons.star, color: Colors.orangeAccent, size: 10)
          ]));

  Widget _buildYourRatingViewWidget() => Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      color: AppColors.backgroundPrimaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AppMenuItem(
          svgIcon: AppIcons.star,
          label: S.of(context).yourRating,
          optionalItem: _buildRatingStarWidget(),
          padding:
              const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
          onTapped: () {}));

  Widget _buildMenuItemTitleWidget(String title) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2)))),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textHighestEmphasisColor)))
          ]);

  Widget _buildYourOrderContainerWidget() => AppMenuItem(
      label: S.of(context).yourOrders,
      hasBottomBorder: true,
      svgIcon: AppIcons.foodOrder,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      onTapped: () {});

  Widget _buildFavouriteOrderContainerWidget() => AppMenuItem(
      label: S.of(context).favouriteOrders,
      hasBottomBorder: true,
      svgIcon: AppIcons.favourite,
      onTapped: () {});

  Widget _buildHiddenRestaurantContainerWidget() => AppMenuItem(
      label: S.of(context).hiddenRestaurants,
      hasBottomBorder: true,
      svgIcon: AppIcons.hiddenRestaurant,
      onTapped: () {});

  Widget _buildAddressBookContainerWidget() => AppMenuItem(
      label: S.of(context).addressBook,
      hasBottomBorder: true,
      svgIcon: AppIcons.addressBook,
      onTapped: () {});

  Widget _buildOnlineOrderHelpContainerWidget() => AppMenuItem(
      label: S.of(context).onlineOrderingHelp,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      svgIcon: AppIcons.message,
      onTapped: () {});

  Widget _buildFoodOrderViewWidget() => Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      color: AppColors.backgroundPrimaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuItemTitleWidget(S.of(context).foodOrders),
                _buildYourOrderContainerWidget(),
                _buildFavouriteOrderContainerWidget(),
                _buildHiddenRestaurantContainerWidget(),
                _buildAddressBookContainerWidget(),
                _buildOnlineOrderHelpContainerWidget()
              ])));

  Widget _buildChooseLanguageContainerWidget() => AppMenuItem(
      label: S.of(context).chooseLanguage,
      hasBottomBorder: true,
      svgIcon: AppIcons.changeLanguage,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      onTapped: () {});

  Widget _buildAboutContainerWidget() => AppMenuItem(
      label: S.of(context).about,
      hasBottomBorder: true,
      icon: Icons.info_outlined,
      onTapped: () {});

  Widget _buildSendFeedbackContainerWidget() => AppMenuItem(
      label: S.of(context).sendFeedback,
      hasBottomBorder: true,
      svgIcon: AppIcons.feedback,
      onTapped: () {});

  Widget _buildReportSafetyWarningContainer() => AppMenuItem(
      label: S.of(context).reportSafetyEmergency,
      hasBottomBorder: true,
      svgIcon: AppIcons.warning,
      onTapped: () {});

  Widget _buildLogOutContainerWidget() => AppMenuItem(
      label: S.of(context).logout,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      svgIcon: AppIcons.logOut,
      onTapped: () => _onLogOutTapped(() {
            Utilities.navigateAndClearAll(context, const Login());
          }));

  Widget _buildMoreMenuViewWidget() => Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      color: AppColors.backgroundPrimaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuItemTitleWidget(S.of(context).more),
                _buildChooseLanguageContainerWidget(),
                _buildAboutContainerWidget(),
                _buildSendFeedbackContainerWidget(),
                _buildReportSafetyWarningContainer(),
                _buildLogOutContainerWidget()
              ])));

  @override
  Widget build(BuildContext context) {
    currentUser = ref.watch(currentUserProvider);
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: AppColors.backgroundTertiaryColor,
        appBar: _buildAppBarWidget(),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                if (currentUser != null) _buildUserInfoViewWidget(),
                _buildHorizontalMenuWidget(),
                if (currentUser != null &&
                    currentUser!.rating != null &&
                    currentUser!.rating! > 0)
                  _buildYourRatingViewWidget(),
                _buildFoodOrderViewWidget(),
                _buildMoreMenuViewWidget()
              ])),
          GenericWidget.buildCircularProgressIndicator(loaderEnabled)
        ]));
  }
}
