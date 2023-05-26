import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ik/Templates/UserTemplate.dart';

class Login_Auth {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static dynamic checkLogin(String username, String password) async {
    List<bool> result = [false, false];
    try {
      QuerySnapshot snap = await firestore.collection("users").get();
      if (snap.docs.isEmpty) {
        return result;
      } else {
        for (var i = 0; i < snap.docs.length; i++) {
          if (username == snap.docs[i]['Username']) {
            result[0] = true;
            if (password == snap.docs[i]['Password']) {
              result[1] = true;
            }
          }
        }
      }
      return result;
    } catch (e) {
      print(e);
      return result;
    }
  }

  static Future<UserTemplate?> getUser(String username) async {
    UserTemplate? user;
    try {
      QuerySnapshot snap = await firestore.collection("users").get();
      for (var i = 0; i < snap.docs.length; i++) {
        if (username == snap.docs[i]['Username']) {
          DocumentSnapshot snapshot =
              await firestore.collection("users").doc(snap.docs[i].id).get();
          return UserTemplate.fromJson(snapshot);
        }
      }
    } catch (e) {
      return user;
    }
    return null;
  }
}
