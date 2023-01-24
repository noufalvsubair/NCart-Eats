import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ncart_eats/firebase/fb_table.dart';

class UserService {
  static Future<bool> hasUserExist(String mobileNumber) async {
    QuerySnapshot<Map<String, dynamic>> queryDocumentSnapshot =
        await FirebaseFirestore.instance
            .collection(FBTable.userTable)
            .limit(1)
            .where('mobile', isEqualTo: mobileNumber)
            .get();

    return queryDocumentSnapshot.size > 0;
  }
}
