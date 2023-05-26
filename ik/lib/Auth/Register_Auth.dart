import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ik/ReusableWidgets.dart';
import 'package:ik/Templates/UserTemplate.dart';
import 'package:ik/User_Provider.dart';
import 'package:uuid/uuid.dart';

class Register_Auth {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static String username = UserProvider.getusername();

  static Future<dynamic> requestOtp(String aadharNo) async {
    final response = await http.post(
      Uri.parse("https://api.emptra.com/aadhaarVerification/requestOtp"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'secretKey':
            'OMZY1uTs13JyOq905hpHK4iveSIrSDT80LEZtWsh7tVzhymShZVA7BVmdkBSUKhRY',
        'clientId':
            'e7ac431fb42d06141f93eafe2861ee8c:56d6e745b82fadfbcb66c550a548b1e0'
      },
      body: jsonEncode(<String, String>{
        'aadhaarNumber': aadharNo,
      }),
    );
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['code'] == 100) {
        if (jsonDecode(response.body)['result']['data']['valid_aadhaar'] ==
            true) {
          if (jsonDecode(response.body)['result']['data']['status'] ==
              "generate_otp_success") {
            dynamic data = jsonDecode(response.body);
            return data['result']['data']['client_id'];
          } else {
            return "Error";
          }
        } else {
          return "Error";
        }
      } else {
        return "Error";
      }
    } else {
      return "Verification Failed";
    }
  }

  static Future<dynamic> submitOtp(String? clientId, String OTP) async {
    print(OTP.runtimeType);
    final response = await http.post(
      Uri.parse("https://api.emptra.com/aadhaarVerification/submitOtp"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'secretKey':
            'OMZY1uTs13JyOq905hpHK4iveSIrSDT80LEZtWsh7tVzhymShZVA7BVmdkBSUKhRY',
        'clientId':
            'e7ac431fb42d06141f93eafe2861ee8c:56d6e745b82fadfbcb66c550a548b1e0'
      },
      body: jsonEncode(<dynamic, dynamic>{
        'client_id': clientId!,
        'otp': OTP,
      }),
    );
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['code'] == 100) {
        dynamic data = jsonDecode(response.body);
        if (data['result']['data']['full_name'] != null) {
          return <String, String>{
            "aadhar": data['result']['data']['aadhaar_number'],
            "name": data['result']['data']['full_name']
            // "aadhar": "483096249638",
            // "photoUrl":
            //     "https://firebasestorage.googleapis.com/v0/b/ice-cream-8838.appspot.com/o/profilepics%2FWIN_20230416_10_56_36_Pro.jpg?alt=media&token=07d4827b-ad8e-4616-96db-8b3ab38ad0e4",
            // "name": "Dhineshkumar Dhandapani"
          };
        }
        else{
          return "Error";
        }
      }else if (jsonDecode(response.body)['code'] == 104) {
        ReusableWidgets.Toast(
            jsonDecode(response.body)['message'].toString(), false);
        return "Error";
      } else {
        return "Error";
      }
    } else {
      return "Verification Failed";
    }
  }

  static UploadProfileImage(Uint8List file, String uid) async {
    try {
      final reference =
          storage.ref().child('profilepics').child("profiles").child(uid);
      final snap = await reference.putData(file);
      final downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> RegisterUser(UserTemplate userData) async {
    try {
      await firestore
          .collection("users")
          .doc(userData.id)
          .set(userData.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> searchUsername(String username) async {
    try {
      QuerySnapshot snap = await firestore.collection("users").get();
      if (snap.docs.isEmpty) {
        return false;
      } else {
        for (var i = 0; i < snap.docs.length; i++) {
          if (username == snap.docs[i]['Username']) {
            return true;
          } else {
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> searchAadhar(String aadhar) async {
    try {
      QuerySnapshot snap = await firestore.collection("users").get();
      if (snap.docs.isEmpty) {
        return false;
      } else {
        for (var i = 0; i < snap.docs.length; i++) {
          if (aadhar == snap.docs[i]['AadharNo']) {
            return true;
          } else {
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Edit_Profile(String name, String photoUrl) async {
    try {
      String id = UserProvider.getUser()!.id;
      await firestore
          .collection("users")
          .doc(id)
          .update({"Name": name, "PhotoUrl": photoUrl});
      QuerySnapshot query = await firestore.collection("posts").get();
      for (var i = 0; i < query.docs.length; i++) {
        await firestore
            .collection("posts")
            .doc(query.docs[i]['photoUrl'])
            .update({'photoUrl': photoUrl});
        QuerySnapshot snap = await firestore
            .collection("posts")
            .doc(query.docs[i].id)
            .collection("comments")
            .get();
        for (var j = 0; j < snap.docs.length; j++) {
          await firestore
              .collection("posts")
              .doc(query.docs[i].id)
              .collection("comments")
              .doc(snap.docs[j].id)
              .update({'PhotoUrl': photoUrl});
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
