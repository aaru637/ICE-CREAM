class Post_Template {
  final String pid;
  final String uid;
  final String username;
  final String photoUrl;
  final String postUrl;
  final String postData;
  final String postType;
  final DateTime datePublished;
  final List likes;
  final List comments;

  const Post_Template({
    required this.pid,
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.postUrl,
    required this.postData,
    required this.postType,
    required this.datePublished,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "pid": pid,
        "username": username,
        "photoUrl": photoUrl,
        "posturl": postUrl,
        "postData": postData,
        "postType": postType,
        "datePublished": datePublished,
        "likes": likes,
        "comments": comments,
      };

  factory Post_Template.fromJson(Map<String, dynamic> json) => Post_Template(
      uid: json['uid'],
      pid: json['pid'],
      username: json['username'],
      photoUrl: json['photoUrl'],
      postUrl: json['postUrl'],
      postData: json['postData'],
      postType: json['postType'],
      datePublished: json['datePublished'],
      likes: json['likes'],
      comments: json['comments']);
}
