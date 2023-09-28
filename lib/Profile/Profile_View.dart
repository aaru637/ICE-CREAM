import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ik/Auth/Follow_Auth.dart';
import 'package:video_player/video_player.dart';

import '../Post_Screens/Image_View.dart';
import '../Post_Screens/Video_View.dart';
import '../User_Provider.dart';

class Profile_View extends StatefulWidget {
  final String id;
  const Profile_View({Key? key, required this.id}) : super(key: key);

  @override
  State<Profile_View> createState() => _Profile_ViewState();
}

class _Profile_ViewState extends State<Profile_View> {
  bool isImage = false;
  bool isFollow = false;
  late VideoPlayerController controller;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          stream: firestore.collection("users").doc(widget.id).snapshots(),
          builder: (context, snapshots) {
            if(snapshots.connectionState == ConnectionState.waiting){
              return Container();
            }
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
                            image: NetworkImage(snapshots.data!['PhotoUrl']),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0001,
                ),
                Text(
                  snapshots.data!['Name'],
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  '@${snapshots.data!['Username']}',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.038),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Follow_Auth.Follow_User(snapshots.data!['id'],
                        snapshots.data!['Following'], snapshots.data!['Followers']);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: snapshots.data!['Followers']
                              .contains(UserProvider.getUser()!.id.toString())
                          ? Colors.grey
                          : Colors.blue),
                  child: snapshots.data!['Followers']
                          .contains(UserProvider.getUser()!.id.toString())
                      ? Text(
                          "Following",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.038,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Follow",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.038,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection("users")
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container();
          }
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
                                  return GestureDetector(
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
