import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ik/Chat_Screens/Contact_Message_View.dart';
import 'package:ik/Chat_Screens/Contacts_Page.dart';
import 'package:ik/Post_Screens/Feed_Post.dart';
import 'package:ik/Profile/Profile_Page.dart';

import '../Post_Screens/Add_Feed.dart';

class Home_Page extends StatefulWidget {
  final dynamic data;
  const Home_Page({Key? key, required this.data}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int index = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int _page) {
    pageController.jumpToPage(_page);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Feed_Post(),
          Contact_Message_View(),
          Add_Feed(),
          Profile_Page(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Colors.amber,
          color: Colors.blue,
          index: index,
          height: 60,
          backgroundColor: Colors.transparent,
          items: const [
            Icon(
              Icons.home,
            ),
            Icon(
              Icons.chat_bubble,
            ),
            Icon(
              Icons.add_circle,
            ),
            Icon(
              Icons.person,
            ),
          ],
          onTap: navigationTapped),
    );
  }
}
