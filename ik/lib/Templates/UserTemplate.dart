import 'package:cloud_firestore/cloud_firestore.dart';

class UserTemplate {
  final String id;
  final String aadharNo;
  final String username;
  final String password;
  final String photoUrl;
  final String Name;
  final List followers;
  final List following;
  final List imagePosts;
  final List videoPosts;

  const UserTemplate(
      {required this.id,
      required this.aadharNo,
      required this.username,
      required this.password,
      required this.photoUrl,
      required this.Name,
      required this.followers,
      required this.following,
      required this.imagePosts,
      required this.videoPosts});

  Map<String, dynamic> toJson() => {
        "id": id,
        "AadharNo": aadharNo,
        "Username": username,
        "Password": password,
        "PhotoUrl": photoUrl,
        "Name": Name,
        "Followers": followers,
        "Following": following,
        "ImagePosts": imagePosts,
        "VideoPosts": videoPosts,
      };

  factory UserTemplate.fromJson(DocumentSnapshot json) => UserTemplate(
      id: json['id'],
      aadharNo: json['AadharNo'],
      username: json['Username'],
      password: json['Password'],
      photoUrl: json['PhotoUrl'],
      Name: json['Name'],
      followers: json['Followers'],
      following: json['Following'],
      imagePosts: json['ImagePosts'],
      videoPosts: json['VideoPosts']);
}
