import 'package:ncart_eats/model/offer/offer.dart';
import 'package:ncart_eats/model/shop/shop.dart';

class DashboardState {
  final List<Offer>? offers;
  final List<Shop>? allShops;



  DashboardState({this.offers, this.allShops});

  factory DashboardState.initial() => DashboardState(offers: [], allShops: []);

  DashboardState copyWith(List<Offer> offers, List<Shop> allShops) =>
      DashboardState(offers: offers, allShops: allShops);

  get openedShops => allShops!.where((Shop shop) => !shop.hasClosed!).toList();

  get closedShops => allShops!.where((Shop shop) => shop.hasClosed!).toList();
}
