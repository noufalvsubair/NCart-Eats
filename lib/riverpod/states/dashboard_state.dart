import 'package:ncart_eats/model/offer/offer.dart';
import 'package:ncart_eats/model/shop/shop.dart';

class DashboardState {
  final List<Offer>? offers;
  final List<Shop>? allShops;
  final List<Shop>? openedShops;
  final List<Shop>? closedShops;

  DashboardState(
      {this.offers, this.allShops, this.openedShops, this.closedShops});

  factory DashboardState.initial() => DashboardState(
      offers: [], allShops: [], openedShops: [], closedShops: []);

  DashboardState copyWith(List<Offer> offers, List<Shop> allShops) =>
      DashboardState(
          offers: offers,
          allShops: allShops,
          openedShops: allShops.where((Shop shop) => !shop.hasClosed!).toList(),
          closedShops: allShops.where((Shop shop) => shop.hasClosed!).toList());
}
