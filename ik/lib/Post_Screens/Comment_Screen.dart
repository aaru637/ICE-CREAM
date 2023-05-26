import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ik/Auth/Post_Auth.dart';
import 'package:intl/intl.dart';
import '../Profile/Profile_Page.dart';
import '../Profile/Profile_View.dart';
import '../User_Provider.dart';

class Comment_Screen extends StatefulWidget {
  final dynamic snap;
  const Comment_Screen({Key? key, required this.snap}) : super(key: key);

  @override
  State<Comment_Screen> createState() => _Comment_ScreenState();
}

class _Comment_ScreenState extends State<Comment_Screen> {
  TextEditingController comment = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    comment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        centerTitle: false,
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
        stream: firestore
            .collection("posts")
            .doc(widget.snap['pid'])
            .collection("comments")
            .orderBy("DatePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (snapshot.data!.docs[index]['UserId'] ==
                              UserProvider.getUser()!.id) {
                            Get.to(() => const Profile_Page(),
                                transition: Transition.upToDown,
                                duration: const Duration(milliseconds: 50));
                          } else {
                            Get.to(() => Profile_View(id: snapshot.data!.docs[index]['UserId']),
                                transition: Transition.upToDown,
                                duration: const Duration(milliseconds: 50));
                          }
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]['PhotoUrl'],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          "${snapshot.data!.docs[index]['Username']} ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: snapshot.data!.docs[index]
                                          ['Comment'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  DateFormat.yMMMMEEEEd().format(snapshot
                                      .data!.docs[index]['DatePublished']
                                      .toDate()),
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await Post_Auth.Like_Comment(
                                    snapshot.data!.docs[index]['PostId'],
                                    snapshot.data!.docs[index]['CommentId'],
                                    UserProvider.getUser()!.id,
                                    snapshot.data!.docs[index]['Likes']);
                              },
                              icon: snapshot.data!.docs[index]['Likes']
                                      .contains(
                                          UserProvider.getUser()!.id.toString())
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite_border),
                            ),
                            Text(snapshot.data!.docs[index]['Likes'].length
                                .toString()),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(UserProvider.getUser()!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: comment,
                    decoration: InputDecoration(
                      hintText: "Comment as ${UserProvider.getUser()!.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Post_Auth.Post_comment(
                      widget.snap['pid'],
                      comment.text.trim(),
                      UserProvider.getUser()!.id,
                      UserProvider.getUser()!.username,
                      UserProvider.getUser()!.photoUrl);
                  setState(() {
                    comment.clear();
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
