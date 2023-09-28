import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ik/Auth/Post_Auth.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:photo_manager/photo_manager.dart';

class Video_Post_Load_Indicator extends StatefulWidget {
  final String video;
  const Video_Post_Load_Indicator({Key? key, required this.video})
      : super(key: key);

  @override
  State<Video_Post_Load_Indicator> createState() =>
      _Video_Post_Load_IndicatorState();
}

class _Video_Post_Load_IndicatorState extends State<Video_Post_Load_Indicator> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Post_Auth.uploadVideoPost(File(widget.video), "videos", context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Post_Auth.uploadTask!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<TaskSnapshot>(
              stream: Post_Auth.uploadTask!.snapshotEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  double progress = data.bytesTransferred / data.totalBytes;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.black),
                        ),
                        child: LiquidCircularProgressIndicator(
                          value: progress,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.pinkAccent),
                          backgroundColor: Colors.white,
                          direction: Axis.vertical,
                          center: Text(
                            '${(100 * progress).roundToDouble()}%',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(
                          '${((snapshot.data!.bytesTransferred.toDouble()) / 1024).toStringAsFixed(2)}KB / ${((snapshot.data!.totalBytes.toDouble()) / 1024).toStringAsFixed(2)}KB'),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Container();
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            "Don't Close this page, until the upload is completed Successfully...",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.blue),
          ),
        ],
      ),
    ));
  }
}
