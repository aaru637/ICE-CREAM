import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Chat_Screens/Chat_Page.dart';
import 'package:ik/User_Provider.dart';
import 'package:get/get.dart';

class Contacts_Page extends StatefulWidget {
  const Contacts_Page({Key? key}) : super(key: key);

  @override
  State<Contacts_Page> createState() => _Contacts_PageState();
}

class _Contacts_PageState extends State<Contacts_Page> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: const Text(
            "Contacts",
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blueGrey,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection("users")
            .where("id", isNotEqualTo: UserProvider.getUser()!.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                            snapshot.data!.docs[index]['PhotoUrl']),
                      ),
                      title: Text(
                        snapshot.data!.docs[index]['Name'],
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        snapshot.data!.docs[index]['Username'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: InkWell(
                          onTap: () {
                            Get.to(
                                () => Chat_Page(
                                    path: "contacts",
                                    usersnapshot:
                                        snapshot.data!.docs[index].data()),
                                transition: Transition.native,
                                duration: const Duration(seconds: 1));
                          },
                          child: Icon(
                            Entypo.message,
                            size: MediaQuery.of(context).size.width * 0.08,
                            color: Colors.blue,
                          )),
                    ),
                  );
                });
          }
          return Container();
        },
      ),
    );
  }
}
