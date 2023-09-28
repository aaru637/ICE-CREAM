import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ik/Templates/Comment_Template.dart';
import 'package:ik/Templates/Post_Template.dart';
import 'package:ik/User_Provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../ReusableWidgets.dart';

class Post_Auth {
  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String username = UserProvider.getusername();
  static UploadTask? uploadTask;

  static Future<void> uploadImagePost(
      Uint8List file, String postType, BuildContext context) async {
    try {
      String pid = const Uuid().v1();
      final reference = storage
          .ref()
          .child('posts')
          .child(postType)
          .child(UserProvider.getUser()!.id)
          .child(pid);
      uploadTask = reference.putData(file);
      final snap = await uploadTask;
      final downloadUrl = await snap!.ref.getDownloadURL();
      Post_Template post = Post_Template(
          pid: pid,
          uid: UserProvider.getUser()!.id,
          username: UserProvider.getusername(),
          photoUrl: UserProvider.getUser()!.photoUrl,
          postUrl: downloadUrl,
          postData: "",
          postType: postType,
          datePublished: DateTime.now(),
          likes: [],
          comments: []);
      firestore.collection('posts').doc(pid).set(post.toJson());
      firestore
          .collection("users")
          .doc(UserProvider.getUser()!.id.toString())
          .update({
        "ImagePosts": FieldValue.arrayUnion([pid])
      });
      ReusableWidgets.Toast("Posted Successfully", true);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  static Future<Uint8List> convert(File file) async {
    Uint8List? data = await VideoThumbnail.thumbnailData(
        video: file.path, imageFormat: ImageFormat.PNG, quality: 25);
    return data!;
  }

  static Future<String> uploadImageData(
      File file, String postType, String pid) async {
    Uint8List? image = await convert(file);
    final reference = storage
        .ref()
        .child('posts')
        .child(postType)
        .child(UserProvider.getUser()!.id)
        .child('imageData')
        .child(pid);
    uploadTask = reference.putData(image);
    final snap1 = await uploadTask;
    final imagedownloadUrl = await snap1!.ref.getDownloadURL();
    return imagedownloadUrl;
  }

  static Future<void> uploadVideoPost(
      File file, String postType, BuildContext context) async {
    try {
      String pid = const Uuid().v1();
      var reference = storage
          .ref()
          .child('posts')
          .child(postType)
          .child(UserProvider.getUser()!.id)
          .child(pid);
      uploadTask = reference.putFile(file);
      final snap = await uploadTask;
      final videodownloadUrl = await snap!.ref.getDownloadURL();
      String imagedownloadUrl = await uploadImageData(file, postType, pid);
      Post_Template post = Post_Template(
          pid: pid,
          uid: UserProvider.getUser()!.id,
          username: UserProvider.getusername(),
          photoUrl: UserProvider.getUser()!.photoUrl,
          postUrl: videodownloadUrl,
          postData: imagedownloadUrl,
          postType: postType,
          datePublished: DateTime.now(),
          likes: [],
          comments: []);
      firestore.collection('posts').doc(pid).set(post.toJson());
      firestore
          .collection('users')
          .doc(UserProvider.getUser()!.id.toString())
          .update({
        'VideoPosts': FieldValue.arrayUnion([pid])
      });
      ReusableWidgets.Toast("Posted Successfully", true);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> LikePost(
      String PostId, String UserId, List Likes, String path) async {
    try {
      if (Likes.contains(UserId)) {
        await firestore.collection(path).doc(PostId).update({
          'likes': FieldValue.arrayRemove([UserId])
        });
      } else {
        await firestore.collection(path).doc(PostId).update({
          'likes': FieldValue.arrayUnion([UserId])
        });
      }
    } catch (e) {}
  }

  static Future<void> Post_comment(String pid, String comment, String uid,
      String username, String photoUrl) async {
    try {
      String CommentId = const Uuid().v1();
      Comment_Template comm = Comment_Template(
          CommentId: CommentId,
          PostId: pid,
          UserId: uid,
          PhotoUrl: photoUrl,
          Username: username,
          Comment: comment,
          DatePublished: DateTime.now(),
          Likes: []);
      await firestore.collection("posts").doc(pid).update({
        'comments': FieldValue.arrayUnion([CommentId])
      });
      await firestore
          .collection("posts")
          .doc(pid)
          .collection("comments")
          .doc(CommentId)
          .set(comm.toJson());
    } catch (e) {}
  }

  static Future<void> Like_Comment(
      String pid, String commentId, String uid, List Likes) async {
    try {
      if (Likes.contains(uid)) {
        await firestore
            .collection("posts")
            .doc(pid)
            .collection("comments")
            .doc(commentId)
            .update({
          'Likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore
            .collection("posts")
            .doc(pid)
            .collection("comments")
            .doc(commentId)
            .update({
          'Likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {}
  }

  static Future<void> deletePost(String PostId, String UserId) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection("posts").doc(PostId).get();
      if (snap['postType'] == 'images') {
        await firestore.collection("posts").doc(PostId).delete();
        DocumentSnapshot documentSnapshot = await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id)
            .get();
        for (var j = 0; j < documentSnapshot['ImagePosts'].length; j++) {
          if (documentSnapshot['ImagePosts'][j] == PostId) {
            await firestore
                .collection("users")
                .doc(UserProvider.getUser()!.id)
                .update({
              'ImagePosts': FieldValue.arrayRemove([PostId])
            });
            break;
          }
        }
        await storage
            .ref()
            .child("posts")
            .child("images")
            .child(UserId)
            .child(PostId)
            .delete();
      } else {
        await firestore.collection("posts").doc(PostId).delete();
        DocumentSnapshot documentSnapshot = await firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id)
            .get();
        for (var j = 0; j < documentSnapshot['VideoPosts'].length; j++) {
          if (documentSnapshot['VideoPosts'][j] == PostId) {
            await firestore
                .collection("users")
                .doc(UserProvider.getUser()!.id)
                .update({
              'VideoPosts': FieldValue.arrayRemove([PostId])
            });
            break;
          }
        }
        await storage
            .ref()
            .child("posts")
            .child("videos")
            .child(UserId)
            .child(PostId)
            .delete();
        await storage
            .ref()
            .child("posts")
            .child("videos")
            .child(UserId)
            .child("imageData")
            .child(PostId)
            .delete();
      }
    } catch (e) {}
  }
}
