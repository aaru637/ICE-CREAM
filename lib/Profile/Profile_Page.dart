import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ik/Post_Screens/Image_View.dart';
import 'package:ik/Post_Screens/Video_View.dart';
import 'package:ik/Profile/Edit_Profile.dart';
import 'package:ik/Templates/UserTemplate.dart';
import 'package:ik/User_Provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../Auth/Post_Auth.dart';
import '../Auth/Report_Auth.dart';
import '../Templates/Report_Template.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key}) : super(key: key);

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  bool isImage = true;
  TextEditingController report = TextEditingController();
  final key = GlobalKey<FormState>();
  late VideoPlayerController controller;
  UserTemplate? user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = UserProvider.getUser();
  }

  @override
  void dispose() {
    // TODO: implement deactivate
    super.dispose();
    try {
      controller.dispose();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
        child: getAppBar(),
      ),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFE1F6F4),
      flexibleSpace: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection("users")
                .doc(UserProvider.getUser()!.id.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                                image: NetworkImage(snapshot.data!['PhotoUrl']),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0001,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const Edit_Profile(),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(seconds: 1));
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.038,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      snapshot.data!['Name'],
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      '@${snapshot.data!['Username']}',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.038),
                    )
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: size.width * 0.07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Posts",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.038,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          ((snapshot.data!['ImagePosts'].length) +
                                  (snapshot.data!['VideoPosts'].length))
                              .toString(),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Followers",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.038,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          snapshot.data!['Followers'].length.toString(),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Following",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.038,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          snapshot.data!['Following'].length.toString(),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isImage = true;
                        });
                      },
                      icon: Icon(
                        Icons.photo,
                        size: size.width * 0.07,
                      ),
                      color: isImage ? Colors.cyan : Colors.black,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isImage = false;
                        });
                      },
                      icon: Icon(
                        Icons.play_circle,
                        size: size.width * 0.07,
                        color: !isImage ? Colors.cyan : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.07,
                ),
                isImage
                    ? Expanded(
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: size.width * 0.04),
                            itemCount: snapshot.data!['ImagePosts'].length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<DocumentSnapshot>(
                                stream: firestore
                                    .collection("posts")
                                    .doc(snapshot.data!['ImagePosts'][index])
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  if (snapshots.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  }
                                  if (!snapshots.hasData) {
                                    return const Center(
                                      child: Text("No Posts Found."),
                                    );
                                  }
                                  return GestureDetector(
                                    onLongPress: () {
                                      snapshot.data!['id'] ==
                                              UserProvider.getUser()!.id
                                          ? showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: const Text(
                                                    "Are you sure to delete this post?\nNote this is not recoverable."),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await Post_Auth
                                                          .deletePost(
                                                              snapshots
                                                                  .data!['pid'],
                                                              snapshots.data![
                                                                  'uid']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Submit the Report against ${snapshots.data!['username']}"),
                                                actions: <Widget>[
                                                  Column(
                                                    children: [
                                                      Form(
                                                        key: key,
                                                        child: TextFormField(
                                                          controller: report,
                                                          validator: (value) {
                                                            if (value?.trim() ==
                                                                "") {
                                                              return "Please Enter your report against ${snapshots.data!['username']}";
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      String ReportId =
                                                          const Uuid().v1();
                                                      Report_Template reports =
                                                          Report_Template(
                                                              UserId: snapshots
                                                                  .data!['uid'],
                                                              PostId: snapshots
                                                                  .data!['pid'],
                                                              ReportId:
                                                                  ReportId,
                                                              Username: snapshots
                                                                      .data![
                                                                  'username'],
                                                              Report:
                                                                  report.text,
                                                              DatePublished:
                                                                  DateTime
                                                                      .now());
                                                      await Report_Auth
                                                          .PostReport(reports);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Submit"),
                                                  ),
                                                ],
                                              ),
                                            );
                                    },
                                    onTap: () {
                                      Get.to(
                                          () => Image_View(
                                                postdata: snapshots.data!,
                                                userdata: snapshot.data!,
                                              ),
                                          transition: Transition.fade,
                                          duration:
                                              const Duration(milliseconds: 50));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.all(size.width * 0.009),
                                      width:
                                          (size.width / 2) - size.width * 0.06,
                                      height:
                                          (size.width / 2) - size.width * 0.06,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                snapshots.data!['posturl'],
                                              ),
                                              fit: BoxFit.fill)),
                                    ),
                                  );
                                },
                              );
                            }),
                      )
                    : Expanded(
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: size.width * 0.04),
                            itemCount: snapshot.data!['VideoPosts'].length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<DocumentSnapshot>(
                                stream: firestore
                                    .collection("posts")
                                    .doc(snapshot.data!['VideoPosts'][index])
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  if (snapshots.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  } else {
                                    return GestureDetector(
                                      onLongPress: () {
                                        snapshot.data!['id'] ==
                                                UserProvider.getUser()!.id
                                            ? showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content: const Text(
                                                      "Are you sure to delete this post?\nNote this is not recoverable."),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await Post_Auth
                                                            .deletePost(
                                                                snapshots.data![
                                                                    'pid'],
                                                                snapshots.data![
                                                                    'uid']);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Delete"),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content: Text(
                                                      "Submit the Report against ${snapshots.data!['username']}"),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        Form(
                                                          key: key,
                                                          child: TextFormField(
                                                            controller: report,
                                                            validator: (value) {
                                                              if (value
                                                                      ?.trim() ==
                                                                  "") {
                                                                return "Please Enter your report against ${snapshots.data!['username']}";
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        String ReportId =
                                                            const Uuid().v1();
                                                        Report_Template
                                                            reports =
                                                            Report_Template(
                                                                UserId: snapshots
                                                                        .data![
                                                                    'uid'],
                                                                PostId: snapshots
                                                                        .data![
                                                                    'pid'],
                                                                ReportId:
                                                                    ReportId,
                                                                Username: snapshots
                                                                        .data![
                                                                    'username'],
                                                                Report:
                                                                    report.text,
                                                                DatePublished:
                                                                    DateTime
                                                                        .now());
                                                        await Report_Auth
                                                            .PostReport(
                                                                reports);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Submit"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      },
                                      onTap: () {
                                        Get.to(
                                            () => Video_View(
                                                  userdata: snapshot.data!,
                                                  postdata: snapshots.data!,
                                                ),
                                            transition: Transition.fade,
                                            duration: const Duration(
                                                milliseconds: 50));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.all(size.width * 0.009),
                                        width: (size.width / 2) -
                                            size.width * 0.06,
                                        height: (size.width / 2) -
                                            size.width * 0.06,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                image: NetworkImage(snapshots
                                                    .data!['postData']),
                                                fit: BoxFit.cover)),
                                      ),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
              ],
            );
          }
          return Container();
        });
  }
}
