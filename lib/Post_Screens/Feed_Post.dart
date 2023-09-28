import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Auth/Post_Auth.dart';
import 'package:ik/Post_Screens/Image_Card.dart';
import 'package:ik/Post_Screens/Video_Card.dart';
import 'package:ik/User_Provider.dart';

class Feed_Post extends StatefulWidget {
  const Feed_Post({Key? key}) : super(key: key);

  @override
  State<Feed_Post> createState() => _Feed_PostState();
}

class _Feed_PostState extends State<Feed_Post> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: getAppBar(),
      ),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    var size = MediaQuery.of(context).size;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.01, top: size.height * 0.03),
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
            )
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    bool isLike = false;
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       "Feed",
          //       style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //           fontSize: size.width * 0.05),
          //     ),
          //     SizedBox(
          //       height: size.height * 0.04,
          //     ),
          //     SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: Row(
          //         children: [
          //           Column(
          //             children: [
          //               Container(
          //                 width: size.width * 0.15,
          //                 height: size.width * 0.15,
          //                 decoration: const BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   gradient: LinearGradient(
          //                     colors: [Color(0x0fffe0df), Color(0xFFE1F6F4)],
          //                   ),
          //                 ),
          //                 child: Center(
          //                   child: Icon(
          //                     Icons.add,
          //                     color: Colors.black,
          //                     size: size.width * 0.07,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: size.height * 0.01,
          //               ),
          //               Text(
          //                 "Add Story",
          //                 style: TextStyle(
          //                     fontSize: size.width * 0.03,
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.black),
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             width: size.width * 0.04,
          //           ),
          //           Row(
          //             children: List.generate(4, (index) {
          //               return Padding(
          //                 padding: const EdgeInsets.only(right: 30),
          //                 child: Column(
          //                   children: [
          //                     Container(
          //                       width: size.width * 0.15,
          //                       height: size.width * 0.15,
          //                       decoration: const BoxDecoration(
          //                         shape: BoxShape.circle,
          //                         image: DecorationImage(
          //                           image: AssetImage(
          //                             "assets/images/profile.jpg",
          //                           ),
          //                           fit: BoxFit.cover,
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: size.height * 0.01,
          //                     ),
          //                     Text(
          //                       "dhinesh123",
          //                       style: TextStyle(
          //                           fontSize: size.width * 0.03,
          //                           fontWeight: FontWeight.bold,
          //                           color: Colors.black),
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             }),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('posts')
                    .orderBy("datePublished", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Post Found",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs[index]['postType'] == "images") {
                        return Image_Card(
                          snapshot: snapshot.data!.docs[index].data(),
                        );
                      }
                      if (snapshot.data!.docs[index]['postType'] == "videos") {
                        return Video_Card(
                            snapshot: snapshot.data!.docs[index].data());
                      }
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
