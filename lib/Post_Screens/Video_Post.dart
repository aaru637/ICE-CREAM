import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Post_Load_Indicator/Video_Post_Load_Indicator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../Auth/Post_Auth.dart';

class Video_Post extends StatefulWidget {
  final String video;
  const Video_Post({Key? key, required this.video}) : super(key: key);

  @override
  State<Video_Post> createState() => _Video_PostState();
}

class _Video_PostState extends State<Video_Post> {
  TextEditingController content = TextEditingController();
  bool isLoading = false;
  late VideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    video(context, widget.video);
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
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
        child: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                Get.off(() => Video_Post_Load_Indicator(video: widget.video),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 50));
              },
              child: Text(
                "POST",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: size.width * 0.04),
              ),
            ),
            SizedBox(
              width: size.width * 0.08,
            ),
          ],
          backgroundColor: Colors.blueGrey,
          title: const Text("POST A VIDEO"),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.02,
          left: size.width * 0.02,
          right: size.width * 0.02,
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.86,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }

  video(BuildContext context, String videoUrl) {
    // File file = compressVideo(videoUrl);
    controller = VideoPlayerController.file(File(videoUrl));
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) => setState(() {}));
    controller.play();
  }
}
