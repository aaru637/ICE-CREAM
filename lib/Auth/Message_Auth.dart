import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ik/Templates/Message.dart';
import 'package:ik/Templates/Message_Template.dart';
import 'package:uuid/uuid.dart';
import '../User_Provider.dart';

class Message_Auth {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<void> sendTextMessage(
      Message_Template mTemp, String message) async {
    try {
      bool isIn = false;
      String MessageId = const Uuid().v1();
      QuerySnapshot user = await firestore
          .collection("users")
          .doc(UserProvider.getUser()!.id)
          .collection("messagepass")
          .get();
      for (var i = 0; i < user.docs.length; i++) {
        if (user.docs[i].id == mTemp.ToUserId) {
          isIn = true;
        }
      }
      if (!isIn) {
        Map<String, dynamic> data = {
          "id": mTemp.ToUserId,
          "PhotoUrl": mTemp.ToPhotoUrl,
          "Username": mTemp.ToUsername,
          "LastMessage": mTemp.LastMessage,
          "DatePublished": DateTime.now(),
        };
        Map<String, dynamic> data1 = {
          "id": mTemp.FromUserId,
          "PhotoUrl": mTemp.FromPhotoUrl,
          "Username": mTemp.FromUsername,
          "LastMessage": mTemp.LastMessage,
          "DatePublished": DateTime.now(),
        };
        await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id)
            .collection("messagepass")
            .doc(mTemp.ToUserId)
            .set(data);
        await firestore
            .collection("users")
            .doc(mTemp.ToUserId)
            .collection("messagepass")
            .doc(UserProvider.getUser()!.id)
            .set(data1);
      } else {
        await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id)
            .collection("messagepass")
            .doc(mTemp.ToUserId)
            .update({
          'DatePublished': DateTime.now(),
          'LastMessage': mTemp.LastMessage
        });
        await firestore
            .collection("users")
            .doc(mTemp.ToUserId)
            .collection("messagepass")
            .doc(UserProvider.getUser()!.id)
            .update({
          'DatePublished': DateTime.now(),
          'LastMessage': mTemp.LastMessage
        });
      }
      Message mess = Message(
          ToUserId: mTemp.ToUserId,
          ToUsername: mTemp.ToUsername,
          ToPhotoUrl: mTemp.ToPhotoUrl,
          MessageId: MessageId,
          MessageType: "text",
          MessageContent: message,
          ImageData: "",
          VideoData: "",
          DatePublished: DateTime.now());
      await firestore
          .collection("users")
          .doc(mTemp.FromUserId)
          .collection("messagepass")
          .doc(mTemp.ToUserId)
          .collection("messages")
          .doc(MessageId)
          .set(mess.tojson());
      await firestore
          .collection("users")
          .doc(mTemp.ToUserId)
          .collection("messagepass")
          .doc(mTemp.FromUserId)
          .collection("messages")
          .doc(MessageId)
          .set(mess.tojson());
    } catch (e) {}
  }

  static Future<void> deleteMessages(String ToUserId, String MessageId,
      String CurrentMessage, String PreviousMessage, int length) async {
    try {
      if (length == 1) {
        print(ToUserId);
        await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id)
            .collection("messagepass")
            .doc(ToUserId)
            .delete();
        // await firestore
        //     .collection("users")
        //     .doc(ToUserId)
        //     .collection("messagepass")
        //     .doc(UserProvider.getUser()!.id)
        //     .delete();
      }
      await firestore
          .collection("users")
          .doc(UserProvider.getUser()!.id)
          .collection("messagepass")
          .doc(ToUserId)
          .collection("messages")
          .doc(MessageId)
          .delete();
      // await firestore
      //     .collection("users")
      //     .doc(ToUserId)
      //     .collection("messagepass")
      //     .doc(UserProvider.getUser()!.id)
      //     .collection("messages")
      //     .doc(MessageId)
      //     .delete();
      final snap = await firestore
          .collection("users")
          .doc(UserProvider.getUser()!.id)
          .collection("messagepass")
          .doc(ToUserId)
          .get();
      if (snap['LastMessage'] == CurrentMessage) {
        await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id)
            .collection("messagepass")
            .doc(ToUserId)
            .update({'LastMessage': PreviousMessage});
        // await firestore
        //     .collection("users")
        //     .doc(ToUserId)
        //     .collection("messagepass")
        //     .doc(UserProvider.getUser()!.id)
        //     .update({'LastMessage': PreviousMessage});
      }
    } catch (e) {}
  }
}
