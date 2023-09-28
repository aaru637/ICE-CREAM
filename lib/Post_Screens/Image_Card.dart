import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Auth/Report_Auth.dart';
import 'package:ik/Post_Screens/Comment_Screen.dart';
import 'package:ik/Profile/Profile_Page.dart';
import 'package:ik/Profile/Profile_View.dart';
import 'package:ik/Templates/Report_Template.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../Auth/Post_Auth.dart';
import '../User_Provider.dart';

class Image_Card extends StatefulWidget {
  final dynamic snapshot;
  const Image_Card({Key? key, this.snapshot}) : super(key: key);

  @override
  State<Image_Card> createState() => _Image_CardState();
}

class _Image_CardState extends State<Image_Card> {
  TextEditingController report = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.06),
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.45,
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
              image: DecorationImage(
                  image: NetworkImage(widget.snapshot['posturl']),
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.20)),
          ),
          Container(
            width: size.width,
            height: size.height * 0.45,
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
                          InkWell(
                            onTap: () {
                              if (widget.snapshot['uid'] ==
                                  UserProvider.getUser()!.id) {
                                Get.to(() => const Profile_Page(),
                                    transition: Transition.upToDown,
                                    duration: const Duration(milliseconds: 50));
                              } else {
                                Get.to(
                                    () => Profile_View(
                                        id: widget.snapshot['uid']),
                                    transition: Transition.upToDown,
                                    duration: const Duration(milliseconds: 50));
                              }
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                widget.snapshot['photoUrl'],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snapshot['username'],
                                style: TextStyle(
                                    fontSize: size.width * 0.038,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: size.height * 0.003,
                              ),
                              Text(
                                DateFormat.yMMMMEEEEd().format(
                                    widget.snapshot['datePublished'].toDate()),
                                style: TextStyle(
                                  fontSize: size.width * 0.03,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      widget.snapshot['uid'] == UserProvider.getUser()!.id
                          ? TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: const Text(
                                        "Are you sure to delete this post?\nNote this is not recoverable."),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await Post_Auth.deletePost(
                                              widget.snapshot['pid'],
                                              widget.snapshot['uid']);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.04),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text(
                                        "Submit the Report against ${widget.snapshot['username']}"),
                                    actions: <Widget>[
                                      Column(
                                        children: [
                                          Form(
                                            key: key,
                                            child: TextFormField(
                                              controller: report,
                                              validator: (value) {
                                                if (value?.trim() == "") {
                                                  return "Please Enter your report against ${widget.snapshot['Username']}";
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
                                          String ReportId = const Uuid().v1();
                                          Report_Template reports =
                                              Report_Template(
                                                  UserId:
                                                      widget.snapshot['uid'],
                                                  PostId:
                                                      widget.snapshot['pid'],
                                                  ReportId: ReportId,
                                                  Username: widget
                                                      .snapshot['username'],
                                                  Report: report.text,
                                                  DatePublished:
                                                      DateTime.now());
                                          await Report_Auth.PostReport(reports);
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
                              widget.snapshot['pid'],
                              UserProvider.getUser()!.id.toString(),
                              widget.snapshot['likes'],
                              "posts");
                        },
                        child: Container(
                          width: size.width * 0.25,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27),
                            color: const Color(0xFFE5E5E5).withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              widget.snapshot['likes']
                                      .contains(UserProvider.getUser()!.id)
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
                                widget.snapshot['likes'].length.toString(),
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
                          Get.to(() => Comment_Screen(snap: widget.snapshot),
                              transition: Transition.downToUp,
                              duration: const Duration(seconds: 1));
                        },
                        child: Container(
                          width: size.width * 0.25,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27),
                            color: const Color(0xFFE5E5E5).withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                MaterialIcons.chat_bubble_outline,
                                color: Colors.white,
                                size: size.width * 0.038,
                              ),
                              Text(
                                widget.snapshot['comments'].length.toString(),
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
    );
  }
}
