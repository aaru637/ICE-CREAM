import 'package:cloud_firestore/cloud_firestore.dart';

class Comment_Template {
  final String CommentId;
  final String PostId;
  final String UserId;
  final String PhotoUrl;
  final String Username;
  final String Comment;
  final DateTime DatePublished;
  final List Likes;

  const Comment_Template({
    required this.CommentId,
    required this.PostId,
    required this.UserId,
    required this.PhotoUrl,
    required this.Username,
    required this.Comment,
    required this.DatePublished,
    required this.Likes,
  });

  Map<String, dynamic> toJson() => {
        "CommentId": CommentId,
        "PostId": PostId,
        "UserId": UserId,
        "PhotoUrl": PhotoUrl,
        "Username": Username,
        "Comment": Comment,
        "DatePublished": DatePublished,
        "Likes": Likes,
      };

  factory Comment_Template.fromJson(Map<String, dynamic> json) =>
      Comment_Template(
          CommentId: json['CommentId'],
          PostId: json['PostId'],
          UserId: json['UserId'],
          PhotoUrl: json['PhotoUrl'],
          Username: json['Username'],
          Comment: json['Comment'],
          DatePublished: json['DatePublished'],
          Likes: json['Likes']);
}
