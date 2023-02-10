import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/dish/dish.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/widget/app_food_item.dart';
import 'package:ncart_eats/widget/app_shop_info_card.dart';

class ShopDetails extends ConsumerStatefulWidget {
  final String shopID;

  const ShopDetails({Key? key, required this.shopID}) : super(key: key);

  @override
  ConsumerState<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends ConsumerState<ShopDetails> {
  Shop? shopInfo;

  @override
  void initState() {
    Future.delayed(Duration.zero, () => _fetchFoodInfo());

    super.initState();
  }

  void _fetchFoodInfo() async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      await ref.read(foodInfoProvider.notifier).fetchFoodInfo(widget.shopID);
      ref.read(loaderIndicatorProvider.notifier).hide();
    } catch (err) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      Utilities.showToastBar(err.toString(), context);
    }
  }

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

  Widget _buildFoodItemDividerWidget() => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Divider(height: 1, color: AppColors.backgroundTertiaryColor));

  Widget _buildFoodListWidget() {
    List<Dish> dishes = ref.watch(foodInfoProvider);

    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dishes.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int itemIndex) => AppFoodItem(
            foodInfo: dishes[itemIndex], hasShopClosed: shopInfo!.hasClosed!),
        separatorBuilder: (BuildContext context, int index) =>
            _buildFoodItemDividerWidget());
  }

  @override
  Widget build(BuildContext context) {
    List<Shop>? allShops = ref.watch(dashboardInfoProvider).allShops;
    shopInfo = allShops!.firstWhere((Shop shop) => shop.id == widget.shopID);

    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: AppColors.backgroundPrimaryColor,
        appBar: _buildAppBarWidget(),
        body: Stack(children: [
          ListView(children: [
            if (shopInfo != null) _buildShopInfoContainerWidget(),
            _buildFoodListWidget(),
            const Padding(padding: EdgeInsets.only(top: 20))
          ]),
          GenericWidget.buildCircularProgressIndicator(loaderEnabled)
        ]));
  }
}
