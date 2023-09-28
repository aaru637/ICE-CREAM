import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ik/User_Provider.dart';

class Follow_Auth {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> Follow_User(
      String uid, List following, List followers) async {
    try {
      if (followers.contains(UserProvider.getUser()!.id)) {
        await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id.toString())
            .update({
          'Following': FieldValue.arrayRemove([uid])
        });
        await firestore.collection("users").doc(uid).update({
          'Followers':
              FieldValue.arrayRemove([UserProvider.getUser()!.id.toString()])
        });
      } else {
        await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id.toString())
            .update({
          'Following': FieldValue.arrayUnion([uid])
        });
        await firestore.collection("users").doc(uid).update({
          'Followers':
              FieldValue.arrayUnion([UserProvider.getUser()!.id.toString()])
        });
      }
    } catch (e) {}
  }
}
