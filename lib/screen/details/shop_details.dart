import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/widget/app_shop_info_card.dart';

class ShopDetails extends ConsumerStatefulWidget {
  final String shopID;

  const ShopDetails({Key? key, required this.shopID}) : super(key: key);

  @override
  ConsumerState<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends ConsumerState<ShopDetails> {
  Shop? shopInfo;

  Widget _buildAppTitleImageWidget() => Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: AppColors.backgroundPrimaryColor),
      child: GenericWidget.buildCachedNetworkImage(shopInfo!.logo!, 0));

  PreferredSize _buildAppBarWidget() => PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.backgroundTertiaryColor,
              statusBarColor: AppColors.backgroundTertiaryColor,
              statusBarIconBrightness: Brightness.dark),
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textHighestEmphasisColor),
          backgroundColor: AppColors.backgroundTertiaryColor,
          title: shopInfo != null && shopInfo!.logo!.isNotEmpty
              ? _buildAppTitleImageWidget()
              : Container()));

  Widget _buildShopInfoContainerWidget() => Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: AppColors.backgroundTertiaryColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: AppShopInfoCard(shopInfo: shopInfo!));

  @override
  Widget build(BuildContext context) {
    List<Shop>? allShops = ref.watch(dashboardInfoProvider).allShops;
    shopInfo = allShops!.firstWhere((Shop shop) => shop.id == widget.shopID);

    return Scaffold(
        backgroundColor: AppColors.backgroundPrimaryColor,
        appBar: _buildAppBarWidget(),
        body: ListView(
            children: [if (shopInfo != null) _buildShopInfoContainerWidget()]));
  }
}
