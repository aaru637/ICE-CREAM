import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Chat_Screens/Chat_Page.dart';
import 'package:ik/Chat_Screens/Contacts_Page.dart';

import '../User_Provider.dart';

class Contact_Message_View extends StatefulWidget {
  const Contact_Message_View({Key? key}) : super(key: key);

  @override
  State<Contact_Message_View> createState() => _Contact_Message_ViewState();
}

class _Contact_Message_ViewState extends State<Contact_Message_View> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigoAccent,
          title: Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.01, top: size.height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                ),
                Text(
                  "ICE-CREAM",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("users")
            .doc(UserProvider.getUser()!.id)
            .collection("messagepass")
            .snapshots(),
        builder: (context, usersnapshot) {
          if (usersnapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (!usersnapshot.hasData) {
            return Center(
              child: Text(
                "Click Below + Icon to Start Message.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.04,
                    color: Colors.black87),
              ),
            );
          }
          if (usersnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Click Below + Icon to Start Message.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.04,
                    color: Colors.black87),
              ),
            );
          }
          return ListView.builder(
            itemCount: usersnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.to(() => Chat_Page(
                      path: "message",
                      usersnapshot: usersnapshot.data!.docs[index].data()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFB2AF83)),
                  child: Center(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.1,
                        backgroundImage: NetworkImage(
                            usersnapshot.data!.docs[index]['PhotoUrl']),
                      ),
                      title: Text(
                        usersnapshot.data!.docs[index]['Username'],
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        usersnapshot.data!.docs[index]['LastMessage'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.13),
        child: FloatingActionButton(
          backgroundColor: Colors.green[900],
          onPressed: () {
            Get.to(() => const Contacts_Page(),
                transition: Transition.downToUp,
                duration: const Duration(seconds: 1));
          },
          child: Icon(
            Icons.message,
            color: Colors.white,
            size: size.width * 0.08,
          ),
        ),
      ),
    );
  }
}
