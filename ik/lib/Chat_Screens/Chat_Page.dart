import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Auth/Message_Auth.dart';
import 'package:ik/Templates/Message_Template.dart';
import 'package:get/get.dart';
import '../Profile/Profile_View.dart';
import '../User_Provider.dart';

class Chat_Page extends StatefulWidget {
  final dynamic usersnapshot;
  final dynamic path;
  const Chat_Page({Key? key, required this.usersnapshot, required this.path})
      : super(key: key);

  @override
  State<Chat_Page> createState() => _Chat_PageState();
}

class _Chat_PageState extends State<Chat_Page> {
  TextEditingController message = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    message.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: size.width * 0.2,
        elevation: 10,
        leadingWidth: size.width * 0.07,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => Profile_View(id: widget.usersnapshot['id']),
                        transition: Transition.upToDown,
                        duration: const Duration(milliseconds: 50));
                  },
                  child: CircleAvatar(
                    radius: size.width * 0.07,
                    backgroundImage: NetworkImage(
                      widget.usersnapshot['PhotoUrl'],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.usersnapshot['Username'],
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("users")
                    .doc(UserProvider.getUser()!.id)
                    .collection("messagepass")
                    .doc(widget.usersnapshot['id'])
                    .collection("messages")
                    .orderBy("DatePublished", descending: true)
                    .snapshots(),
                builder: (context, messagesnapshot) {
                  if (messagesnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  }
                  if (messagesnapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "Type any Message to make Conversation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.04,
                            color: Colors.black87),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: messagesnapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onLongPress: () async {
                          if(messagesnapshot.data!.docs[i]['ToUserId'] == UserProvider.getUser()!.id){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content:
                                Text("Are you sure to Delete this Message?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      print(widget.usersnapshot
                                      ['id']);
                                      await Message_Auth.deleteMessages(
                                          widget.usersnapshot
                                          ['id'],
                                          messagesnapshot.data!.docs[i].id,
                                          messagesnapshot.data!.docs[i]
                                          ['MessageContent'],
                                          i > 0
                                              ? ((i ==
                                              messagesnapshot
                                                  .data!.docs.length -
                                                  1)
                                              ? messagesnapshot.data!.docs[i - 1]
                                          ['MessageContent']
                                              : messagesnapshot
                                              .data!.docs[i + 1]
                                          ['MessageContent'])
                                              : "",
                                          messagesnapshot.data!.docs.length);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content:
                                Text("Are you sure to Delete this Message?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await Message_Auth.deleteMessages(
                                          messagesnapshot.data!.docs[i]
                                          ['ToUserId'],
                                          messagesnapshot.data!.docs[i].id,
                                          messagesnapshot.data!.docs[i]
                                          ['MessageContent'],
                                          i > 0
                                              ? ((i ==
                                              messagesnapshot
                                                  .data!.docs.length -
                                                  1)
                                              ? messagesnapshot.data!.docs[i - 1]
                                          ['MessageContent']
                                              : messagesnapshot
                                              .data!.docs[i + 1]
                                          ['MessageContent'])
                                              : "",
                                          messagesnapshot.data!.docs.length);
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          }
                          print(i);
                          print(messagesnapshot.data!.docs.length);

                        },
                        child: Align(
                          alignment: messagesnapshot.data!.docs[i]
                                      ['ToUserId'] !=
                                  UserProvider.getUser()!.id
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width * 0.03,
                                    right: size.width * 0.03,
                                    top: size.height * 0.04),
                                padding: EdgeInsets.all(size.width * 0.04),
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(18)),
                                child: Text(
                                  messagesnapshot.data!.docs[i]
                                      ['MessageContent'],
                                  style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Times New Roman",
                                      letterSpacing: 1.1,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFD78484),
                  ),
                  margin: EdgeInsets.all(size.width * 0.02),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,
                            controller: message,
                            decoration: const InputDecoration(
                              hintText: "Message",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.05),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: Container(
                      //     padding: EdgeInsets.only(
                      //         left: size.width * 0.04,
                      //         right: size.width * 0.04),
                      //     child: Icon(
                      //       Feather.image,
                      //       color: Colors.yellowAccent,
                      //       size: size.height * 0.04,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      InkWell(
                        onTap: () async {
                          Message_Template sender = Message_Template(
                              FromUserId: UserProvider.getUser()!.id,
                              ToUserId: widget.usersnapshot['id'],
                              FromUsername: UserProvider.getUser()!.username,
                              ToUsername: widget.usersnapshot['Username'],
                              FromPhotoUrl: UserProvider.getUser()!.photoUrl,
                              ToPhotoUrl: widget.usersnapshot['PhotoUrl'],
                              LastMessage: message.text.trim());
                          await Message_Auth.sendTextMessage(
                              sender, message.text.trim());
                          message.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: size.width * 0.04),
                          child: Icon(
                            Feather.send,
                            color: Colors.yellowAccent,
                            size: size.height * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
