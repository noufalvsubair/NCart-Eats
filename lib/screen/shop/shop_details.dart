import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/shared_preference.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/cart/cart.dart';
import 'package:ncart_eats/model/dish/dish.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/widget/app_bottom_cart_info_card.dart';
import 'package:ncart_eats/widget/app_category_item.dart';
import 'package:ncart_eats/widget/app_dish_item.dart';
import 'package:ncart_eats/widget/app_dish_replace_dialog.dart';
import 'package:ncart_eats/widget/app_shop_info_card.dart';

class ShopDetails extends ConsumerStatefulWidget {
  final String shopID;

  const ShopDetails({Key? key, required this.shopID}) : super(key: key);

  @override
  ConsumerState<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends ConsumerState<ShopDetails> {
  late ScrollController mainScrollController;

  Shop? shopInfo;
  late String selectedDishType;
  late bool hasBestSellerSelected;
  late List<Cart> carts;

  @override
  void initState() {
    mainScrollController = ScrollController();
    selectedDishType = "";
    hasBestSellerSelected = false;
    carts = [];

    Future.delayed(Duration.zero, () => _fetchFoodInfo());

    super.initState();
  }

  @override
  void dispose() {
    mainScrollController.dispose();
    _saveCartToDB();

    super.dispose();
  }

  void _fetchFoodInfo() async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      await ref.read(dishInfoProvider.notifier).fetchFoodInfo(widget.shopID);
      _fetchCartInfo();
      ref.read(loaderIndicatorProvider.notifier).hide();
    } catch (err) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      Utilities.showToastBar(err.toString(), context);
    }
  }

  void _fetchCartInfo() async {
    List<Cart> currentCarts = await SharedPreferenceHelper.shared.getCart();

    setState(() => carts = currentCarts);
  }

  void _saveCartToDB() async {
    await SharedPreferenceHelper.shared.setCart(carts);
  }

  void _onAddOrUpdateCartTapped(Dish dishInfo, int quantity) {
    if (carts.isNotEmpty && carts.first.shopID != widget.shopID) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AppDishReplaceDialog(
                cartShopName: carts.first.shopName!,
                currentShopName: shopInfo!.name!,
                onReplaceTapped: () {
                  _addAndUpdateToCart(dishInfo, quantity, true);
                  Navigator.pop(context);
                },
                onNoTapped: () => Navigator.pop(context),
              ));

      return;
    }

    _addAndUpdateToCart(dishInfo, quantity, false);
  }

  void _addAndUpdateToCart(Dish dishInfo, int quantity, bool keepEmpty) {
    if (keepEmpty) {
      carts.clear();
    }

    if (quantity > 0) {
      int index = carts.indexWhere((Cart cart) => cart.dishID == dishInfo.id);
      Cart currentCart = Cart(
          id: DateTime.now().millisecondsSinceEpoch.toDouble(),
          shopID: shopInfo!.id!,
          shopName: shopInfo!.name!,
          dishID: dishInfo.id,
          dishName: dishInfo.name,
          price: dishInfo.price,
          type: dishInfo.type,
          quantity: quantity);

      if (index >= 0) {
        carts[index] = currentCart;
      } else {
        carts.add(currentCart);
      }
    } else {
      carts.removeWhere((Cart cart) => cart.dishID == dishInfo.id);
    }

    setState(() {});
  }

  void _scrollToTop() {
    if (mainScrollController.position.pixels > 45) {
      mainScrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  Widget _buildAppTitleImageWidget() =>
      shopInfo != null && shopInfo!.logo!.isNotEmpty
          ? Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundPrimaryColor),
              child: GenericWidget.buildCachedNetworkImage(shopInfo!.logo!, 0))
          : Container();

  Widget _buildAppTitleTextWidget() =>
      shopInfo != null && shopInfo!.name!.isNotEmpty
          ? Text(shopInfo!.name!,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: AppColors.textHighestEmphasisColor,
                  fontWeight: FontWeight.w700))
          : Container();

  Widget _buildAppBarSearchAndTypeContainerWidget() {
    double pixelMetrics = ref.watch(scrollInfoProvider);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pixelMetrics > 285) _buildDishSearchBarWidget(),
          if (pixelMetrics > 333) _buildDishTypeAndCategoryContainer()
        ]);
  }

  PreferredSize _buildAppBarWidget() {
    double pixelMetrics = ref.watch(scrollInfoProvider);

    return PreferredSize(
        preferredSize: pixelMetrics > 333
            ? const Size.fromHeight(110)
            : pixelMetrics > 285
                ? const Size.fromHeight(60)
                : const Size.fromHeight(50),
        child: AppBar(
            toolbarHeight: 110,
            systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: AppColors.backgroundTertiaryColor,
                statusBarColor: pixelMetrics > 48
                    ? AppColors.backgroundPrimaryColor
                    : AppColors.backgroundTertiaryColor,
                statusBarIconBrightness: Brightness.dark),
            elevation: pixelMetrics > 48 ? 10 : 0.0,
            centerTitle: true,
            titleSpacing: 0,
            automaticallyImplyLeading: pixelMetrics <= 285,
            iconTheme: IconThemeData(color: AppColors.textHighestEmphasisColor),
            backgroundColor: pixelMetrics > 48
                ? AppColors.backgroundPrimaryColor
                : AppColors.backgroundTertiaryColor,
            title: pixelMetrics > 285
                ? _buildAppBarSearchAndTypeContainerWidget()
                : pixelMetrics > 48
                    ? _buildAppTitleTextWidget()
                    : _buildAppTitleImageWidget()));
  }

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

  Widget _buildDishesMenuTitleWidget() => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Center(
          child: Text(S.of(context).menu,
              style: GoogleFonts.roboto(
                  color: AppColors.textHighestEmphasisColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 16))));

  Widget _buildSearchBackButtonWidget() {
    double pixelMetrics = ref.watch(scrollInfoProvider);

    return pixelMetrics > 285
        ? InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios,
                color: AppColors.textHighestEmphasisColor, size: 20))
        : const SizedBox(width: 20);
  }

  Widget _buildSearchBarHintTextWidget() {
    double pixelMetrics = ref.watch(scrollInfoProvider);

    return RichText(
        text: TextSpan(
            text: pixelMetrics > 285
                ? S.of(context).searchIn
                : S.of(context).searchForDishes,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textHighestEmphasisColor),
            children: [
          if (pixelMetrics > 285)
            TextSpan(
                text: shopInfo!.name!,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textHighestEmphasisColor))
        ]));
  }

  Widget _buildDishSearchBarWidget() {
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
        height: 40,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.textLowEmphasisColor.withOpacity(0.2)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSearchBackButtonWidget(),
              _buildSearchBarHintTextWidget(),
              SvgPicture.asset(AppIcons.search, width: 20, height: 20)
            ]));
  }

  Widget _buildVegTypeContainerWidget() => AppCategoryItem(
      label: S.of(context).veg,
      type: 'veg',
      isSelected: selectedDishType == 'veg',
      onTapped: () {
        _scrollToTop();
        setState(
            () => selectedDishType = selectedDishType == 'veg' ? '' : 'veg');
      });

  Widget _buildNonVegTypeContainerWidget() => AppCategoryItem(
      label: S.of(context).nonVeg,
      type: 'non-veg',
      isSelected: selectedDishType == 'non-veg',
      onTapped: () {
        _scrollToTop();
        setState(() =>
            selectedDishType = selectedDishType == 'non-veg' ? '' : 'non-veg');
      });

  Widget _buildBestSellerContainerWidget() => AppCategoryItem(
      label: S.of(context).bestSeller,
      isSelected: hasBestSellerSelected,
      onTapped: () {
        _scrollToTop();
        setState(() => hasBestSellerSelected = !hasBestSellerSelected);
      });

  Widget _buildDishTypeAndCategoryContainer() {
    List<Dish> dishes = ref.watch(dishInfoProvider);
    double pixelMetrics = ref.watch(scrollInfoProvider);

    bool vegContainerEnabled =
        dishes.where((Dish dish) => dish.type == 'veg').toList().isNotEmpty;
    bool nonVegContainerEnabled =
        dishes.where((Dish dish) => dish.type == 'non-veg').toList().isNotEmpty;
    bool bestSellerContainerEnabled =
        dishes.where((Dish dish) => dish.isBestSeller!).toList().isNotEmpty;

    return Container(
        color: pixelMetrics > 333
            ? AppColors.backgroundPrimaryColor
            : AppColors.backgroundTertiaryColor,
        padding: pixelMetrics > 333
            ? const EdgeInsets.only(left: 15, bottom: 10)
            : const EdgeInsets.only(left: 15, top: 15, bottom: 15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (vegContainerEnabled) _buildVegTypeContainerWidget(),
              if (nonVegContainerEnabled) _buildNonVegTypeContainerWidget(),
              if (bestSellerContainerEnabled) _buildBestSellerContainerWidget()
            ]));
  }

  List<Dish> _getFilteredDishes(List<Dish> dishes) {
    List<Dish> filteredDishes = dishes;
    if (selectedDishType.isNotEmpty) {
      filteredDishes =
          dishes.where((Dish dish) => dish.type == selectedDishType).toList();
    }

    if (hasBestSellerSelected) {
      filteredDishes =
          filteredDishes.where((Dish dish) => dish.isBestSeller!).toList();
    }

    return filteredDishes;
  }

  Widget _buildFoodListWidget() {
    List<Dish> filteredDishes = _getFilteredDishes(ref.watch(dishInfoProvider));

    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredDishes.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int itemIndex) => AppDishItem(
            foodInfo: filteredDishes[itemIndex],
            hasShopClosed: shopInfo!.hasClosed!,
            carts: carts,
            addOrUpdateCart: (int quantity) =>
                _onAddOrUpdateCartTapped(filteredDishes[itemIndex], quantity)),
        separatorBuilder: (BuildContext context, int index) =>
            _buildFoodItemDividerWidget());
  }

  Widget _buildBottomCartInfoCardWidget() =>
      carts.isNotEmpty && !shopInfo!.hasClosed!
          ? Positioned(
              bottom: 15,
              left: 15,
              child: AppBottomCartInfoCard(carts: carts, shopID: widget.shopID))
          : Container();

  Widget _buildMainListContainerWidget() => NotificationListener(
      onNotification: (ScrollNotification notification) {
        ref
            .read(scrollInfoProvider.notifier)
            .setPixel(notification.metrics.pixels);

        return true;
      },
      child: ListView(controller: mainScrollController, children: [
        if (shopInfo != null) _buildShopInfoContainerWidget(),
        _buildDishesMenuTitleWidget(),
        _buildDishSearchBarWidget(),
        _buildDishTypeAndCategoryContainer(),
        _buildFoodListWidget(),
        SizedBox(height: carts.isEmpty || shopInfo!.hasClosed! ? 20 : 80)
      ]));

  @override
  Widget build(BuildContext context) {
    shopInfo = ref
        .watch(dashboardInfoProvider)
        .allShops!
        .firstWhere((Shop shop) => shop.id == widget.shopID);
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: AppColors.backgroundPrimaryColor,
        appBar: _buildAppBarWidget(),
        body: Stack(children: [
          _buildMainListContainerWidget(),
          _buildBottomCartInfoCardWidget(),
          GenericWidget.buildCircularProgressIndicator(loaderEnabled)
        ]));
  }
}
