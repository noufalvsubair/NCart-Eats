import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ncart_eats/firebase/fb_table.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';

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

  static Future<bool> addUserToDB(CurrentUser user) async {
    try {
      bool hasExist = await hasUserExist(user.mobile!);
      if (hasExist) {
        return Future.error(409);
      }

      CollectionReference usersCollectionRef =
          FirebaseFirestore.instance.collection(FBTable.userTable);
      DocumentReference documentReference =
          await usersCollectionRef.add(user.toJson());
      await documentReference.update({"uid": documentReference.id});

      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<CurrentUser> fetchUserByMobileNumber(
      String? mobileNumber) async {
    QuerySnapshot<Map<String, dynamic>> queryDocumentSnapshot =
        await FirebaseFirestore.instance
            .collection(FBTable.userTable)
            .limit(1)
            .where('mobile', isEqualTo: mobileNumber)
            .get();

    return CurrentUser.fromJson(queryDocumentSnapshot.docs.first.data());
  }
}
