import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ik/Post_Load_Indicator/Image_Post_Load_Indicator.dart';

class Image_Post extends StatefulWidget {
  final Uint8List? image;
  const Image_Post({Key? key, required this.image})
      : super(key: key);

  @override
  State<Image_Post> createState() => _Image_PostState();
}

class _Image_PostState extends State<Image_Post> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          TextButton(
            onPressed: () {
              Get.off(() => Image_Post_Load_Indicator(image: widget.image!),
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
        centerTitle: true,
        elevation: 0,
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.86,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                image: DecorationImage(
                    image: MemoryImage(widget.image!), fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
