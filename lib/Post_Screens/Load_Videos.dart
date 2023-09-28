import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ik/Post_Screens/Video_Post.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;

class Load_Videos extends StatefulWidget {
  const Load_Videos({Key? key}) : super(key: key);

  @override
  State<Load_Videos> createState() => _Load_VideosState();
}

class _Load_VideosState extends State<Load_Videos> {
  List<String> videoList = [];
  List<Uint8List> thumbnail = [];
  List<AssetEntity> videos = [];
  List<AssetEntity> vid1 = [];
  List<AssetEntity> assets = [];
  static const platform = MethodChannel("com.ik.ik/imageFetcher");
  bool isLoad = false;

  void getVideos() async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) return PhotoManager.openSetting();
      final List<dynamic> result = await platform.invokeMethod('getAllVideos');
      setState(() {
        videoList = List<String>.from(result);
      });
      print(videoList);
    } catch (e) {
      print('Error : ${e}');
    }
  }

  String getFileLength(String video) {
    File file = File(video);
    double size = file.lengthSync() / 1048576;
    return (size > 1024)
        ? "${(size / 1024).toStringAsFixed(2)} GB "
        : "${size.toStringAsFixed(2)} MB";
  }

  int current = 0;
  int? last;

  handleScroll(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent <= .33) return;
    if (current == last) return;
    getVideos();
  }

  @override
  void initState() {
    // TODO: implement initState
    getVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return videoList.isEmpty
        ? const Center(
            child: Text(
              "No Videos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Scaffold(
            extendBody: true,
            backgroundColor: Colors.blueGrey,
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll) {
                handleScroll(scroll);
                return true;
              },
              child: ListView.builder(
                itemCount: videoList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Get.to(() => Video_Post(video: videoList[index]),
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      child: Card(
                        color: Colors.greenAccent,
                        child: ListTile(
                          splashColor: Colors.white,
                          title: Text(
                            path.basename(videoList[index]).length > 40
                                ? path
                                    .basename(videoList[index])
                                    .substring(0, 40)
                                : path.basename(videoList[index]),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.02),
                            child: Text(getFileLength(videoList[index])),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
