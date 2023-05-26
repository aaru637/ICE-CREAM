import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ik/Post_Screens/Video_Post.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class Load_Videos extends StatefulWidget {
  const Load_Videos({Key? key}) : super(key: key);

  @override
  State<Load_Videos> createState() => _Load_VideosState();
}

class _Load_VideosState extends State<Load_Videos> {
  List<AssetEntity> videoList = [];
  int current = 0;
  int? last;

  handleScroll(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent <= .33) return;
    if (current == last) return;
    pickVideos();
  }

  late VideoPlayerController controller;

  dynamic pickVideos() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return PhotoManager.openSetting();

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video, onlyAll: true);

    try {
      List<AssetEntity> videos =
          await albums[0].getAssetListPaged(page: current, size: 24);
      setState(() {
        videoList.addAll(videos);
        current++;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    pickVideos();
    super.initState();
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
              child: GridView.builder(
                itemCount: videoList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Get.to(() => Video_Post(video: videoList[index]),
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: AssetEntityImage(
                        videoList[index],
                        isOriginal: false,
                        thumbnailSize: const ThumbnailSize.square(200),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
