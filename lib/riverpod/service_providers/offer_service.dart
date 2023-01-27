import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ncart_eats/firebase/fb_table.dart';
import 'package:ncart_eats/model/offer/offer.dart';

class OfferService extends StateNotifier<List<Offer>> {
  OfferService() : super([]);

  Future<void> fetchOffers() async {
    try {
      List<Offer> offers = [];
      QuerySnapshot<Map<String, dynamic>> offerCollectionRef =
          await FirebaseFirestore.instance.collection(FBTable.offerTable).get();
      for (DocumentSnapshot doc in offerCollectionRef.docs) {
        Map<String, dynamic>? offerJson = doc.data() as Map<String, dynamic>?;
        offers.add(Offer.fromJson(offerJson!));
      }
      state = offers;
    } catch (err) {
      return Future.error(err);
    }
  }
}
