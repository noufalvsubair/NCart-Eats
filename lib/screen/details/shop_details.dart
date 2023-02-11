import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/shared_preference.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/cart/cart.dart';
import 'package:ncart_eats/model/dish/dish.dart';
import 'package:ncart_eats/model/shop/shop.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/widget/app_category_item.dart';
import 'package:ncart_eats/widget/app_dish_item.dart';
import 'package:ncart_eats/widget/app_shop_info_card.dart';

class ShopDetails extends ConsumerStatefulWidget {
  final String shopID;

  const ShopDetails({Key? key, required this.shopID}) : super(key: key);

  @override
  ConsumerState<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends ConsumerState<ShopDetails> {
  Shop? shopInfo;
  late String selectedDishType;
  late bool hasBestSellerSelected;
  late List<CartItem> cartItems;

  @override
  void initState() {
    selectedDishType = "";
    hasBestSellerSelected = false;
    cartItems = [];

    Future.delayed(Duration.zero, () {
      _fetchCartInfo();
      _fetchFoodInfo();
    });

    super.initState();
  }

  @override
  void dispose() {
    _saveCartToDB();

    super.dispose();
  }

  void _fetchFoodInfo() async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      await ref.read(dishInfoProvider.notifier).fetchFoodInfo(widget.shopID);
      ref.read(loaderIndicatorProvider.notifier).hide();
    } catch (err) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      Utilities.showToastBar(err.toString(), context);
    }
  }

  void _fetchCartInfo() async {
    Cart? currentCart = await SharedPreferenceHelper.shared.getCart();
    if (currentCart != null && currentCart.shopID! == widget.shopID) {
      cartItems = currentCart.cartItems ?? [];
    }

    setState(() {});
  }

  void _saveCartToDB() async {
    if (cartItems.isNotEmpty) {
      Cart currentCart = Cart(
          id: DateTime.now().millisecondsSinceEpoch.toDouble(),
          shopID: widget.shopID,
          cartItems: cartItems);
      await SharedPreferenceHelper.shared.setCart(currentCart);
    }
  }

  void _addOrUpdateCartItem(Dish dish, int quantity) {
    int index =
        cartItems.indexWhere((CartItem cartItem) => cartItem.dishID == dish.id);
    CartItem cartItem = CartItem(
        dishID: dish.id!,
        name: dish.name!,
        quantity: quantity,
        price: dish.price!,
        type: dish.type!);
    if (index >= 0) {
      cartItems[index] = cartItem;
    } else {
      cartItems.add(cartItem);
    }

    setState(() {});
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

  Widget _buildShopInfoContainerWidget() {
    return Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: AppColors.backgroundTertiaryColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: AppShopInfoCard(shopInfo: shopInfo!));
  }

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

  Widget _buildDishSearchBarWidget() => Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.textLowEmphasisColor.withOpacity(0.2)),
      child: Stack(children: [
        Center(
            child: Text(S.of(context).searchForDishes,
                style: GoogleFonts.encodeSans(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: AppColors.textMedEmphasisColor))),
        Positioned(
            right: 10,
            top: 10,
            child: Icon(Icons.search_outlined,
                size: 20, color: AppColors.textMedEmphasisColor))
      ]));

  Widget _buildVegTypeContainerWidget() => AppCategoryItem(
      label: S.of(context).veg,
      type: 'veg',
      isSelected: selectedDishType == 'veg',
      onTapped: () => setState(
          () => selectedDishType = selectedDishType == 'veg' ? '' : 'veg'));

  Widget _buildNonVegTypeContainerWidget() => AppCategoryItem(
      label: S.of(context).nonVeg,
      type: 'non-veg',
      isSelected: selectedDishType == 'non-veg',
      onTapped: () => setState(() =>
          selectedDishType = selectedDishType == 'non-veg' ? '' : 'non-veg'));

  Widget _buildBestSellerContainerWidget() => AppCategoryItem(
      label: S.of(context).bestSeller,
      isSelected: hasBestSellerSelected,
      onTapped: () =>
          setState(() => hasBestSellerSelected = !hasBestSellerSelected));

  Widget _buildDishTypeAndCategoryContainer() {
    List<Dish> dishes = ref.watch(dishInfoProvider);
    bool vegContainerEnabled =
        dishes.where((Dish dish) => dish.type == 'veg').toList().isNotEmpty;
    bool nonVegContainerEnabled =
        dishes.where((Dish dish) => dish.type == 'non-veg').toList().isNotEmpty;
    bool bestSellerContainerEnabled =
        dishes.where((Dish dish) => dish.isBestSeller!).toList().isNotEmpty;

    return Container(
        color: AppColors.backgroundTertiaryColor,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
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
            cartItems: cartItems,
            addOrUpdateCart: (int quantity) =>
                _addOrUpdateCartItem(filteredDishes[itemIndex], quantity)),
        separatorBuilder: (BuildContext context, int index) =>
            _buildFoodItemDividerWidget());
  }

  Widget _buildCircularProgressIndicatorWidget() {
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return GenericWidget.buildCircularProgressIndicator(loaderEnabled);
  }

  @override
  Widget build(BuildContext context) {
    shopInfo = ref
        .watch(dashboardInfoProvider)
        .allShops!
        .firstWhere((Shop shop) => shop.id == widget.shopID);

    return Scaffold(
        backgroundColor: AppColors.backgroundPrimaryColor,
        appBar: _buildAppBarWidget(),
        body: Stack(children: [
          ListView(children: [
            if (shopInfo != null) _buildShopInfoContainerWidget(),
            _buildDishesMenuTitleWidget(),
            _buildDishSearchBarWidget(),
            _buildDishTypeAndCategoryContainer(),
            _buildFoodListWidget(),
            // const Padding(padding: EdgeInsets.only(top: 20))
          ]),
          _buildCircularProgressIndicatorWidget()
        ]));
  }
}
