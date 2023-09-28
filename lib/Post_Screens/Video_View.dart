import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Profile/Profile_Page.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../Auth/Post_Auth.dart';
import '../Auth/Report_Auth.dart';
import '../Templates/Report_Template.dart';
import '../User_Provider.dart';
import 'Comment_Screen.dart';

class Video_View extends StatefulWidget {
  final dynamic userdata;
  final dynamic postdata;
  const Video_View({
    Key? key,
    required this.userdata,
    required this.postdata,
  }) : super(key: key);

  @override
  State<Video_View> createState() => _Video_ViewState();
}

class _Video_ViewState extends State<Video_View> {
  late VideoPlayerController controller;
  bool isPlaying = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController report = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    video(context, widget.postdata['posturl']);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    try {
      controller.dispose();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          setState(
            () {
              controller.value.isPlaying
                  ? {controller.pause(), isPlaying = false}
                  : {controller.play(), isPlaying = true};
            },
          );
        },
        child: Padding(
                padding: EdgeInsets.only(
                  bottom: size.height * 0.02,
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.99,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 15,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                controller.value.isPlaying
                                    ? controller.pause()
                                    : controller.play();
                              },
                            );
                          },
                          child: VideoPlayer(controller),
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.99,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: isPlaying
                            ? const SizedBox.shrink()
                            : Container(
                                color: Colors.black26,
                                child: const Center(
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.99,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.20)),
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.99,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            widget.userdata['PhotoUrl']),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.03,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.userdata['Username'],
                                            style: TextStyle(
                                                fontSize: size.width * 0.038,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.003,
                                          ),
                                          Text(
                                            DateFormat.yMMMMEEEEd().format(
                                                widget.postdata['datePublished']
                                                    .toDate()),
                                            style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  widget.postdata['uid'] ==
                                          UserProvider.getUser()!.id
                                      ? Container() : TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Submit the Report against ${widget.postdata['username']}"),
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
                                                              return "Please Enter your report against ${widget.postdata['username']}";
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      String ReportId =
                                                          const Uuid().v1();
                                                      Report_Template reports =
                                                          Report_Template(
                                                              UserId: widget.postdata['uid'],
                                                              PostId: widget.postdata['pid'],
                                                              ReportId: ReportId,
                                                              Username:
                                                              widget.postdata[
                                                                      'username'],
                                                              Report: report.text,
                                                              DatePublished:
                                                                  DateTime.now());
                                                      await Report_Auth
                                                          .PostReport(reports);
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text("Submit"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Report",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.width * 0.04),
                                          ),
                                        ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await Post_Auth.LikePost(
                                          widget.postdata['pid'],
                                          UserProvider.getUser()!.id.toString(),
                                          widget.postdata['likes'],
                                          "posts");
                                    },
                                    child: Container(
                                      width: size.width * 0.25,
                                      height: size.width * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(27),
                                        color: const Color(0xFFE5E5E5)
                                            .withOpacity(0.5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          widget.postdata['likes'].contains(
                                                  UserProvider.getUser()!.id)
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: size.width * 0.038,
                                                )
                                              : Icon(
                                                  Icons.favorite_border,
                                                  size: size.width * 0.038,
                                                ),
                                          Text(
                                            widget.postdata['likes'].length
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: size.width * 0.038,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          () => Comment_Screen(
                                              snap: widget.postdata),
                                          transition: Transition.downToUp,
                                          duration: const Duration(seconds: 1));
                                    },
                                    child: Container(
                                      width: size.width * 0.25,
                                      height: size.width * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(27),
                                        color: const Color(0xFFE5E5E5)
                                            .withOpacity(0.5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            MaterialIcons.chat_bubble_outline,
                                            color: Colors.white,
                                            size: size.width * 0.038,
                                          ),
                                          Text(
                                            widget.postdata['comments'].length
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: size.width * 0.038,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  video(BuildContext context, String videoUrl) {
    controller = VideoPlayerController.network(videoUrl);
    controller.addListener(() {
      setState(() {});
    });
    controller.setLooping(true);
    controller.initialize().then((value) => setState(() {}));
  }
}
