import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ik/Post_Screens/Image_Post.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

class Load_Images extends StatefulWidget {
  const Load_Images({Key? key}) : super(key: key);

  @override
  State<Load_Images> createState() => _Load_ImagesState();
}

class _Load_ImagesState extends State<Load_Images> {
  List<String> imageList = [];
  static const platform = MethodChannel("com.ik.ik/imageFetcher");
  bool isLoad = false;

  void getImages() async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) return PhotoManager.openSetting();
      final List<dynamic> result = await platform.invokeMethod('getAllImages');
      setState(() {
        imageList = List<String>.from(result);
        isLoad = true;
      });
    } catch (e) {
      print('Error : ${e.toString()}');
    }
  }

  int current = 0;
  int? last;

  handleScroll(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent <= .33) return;
    if (current == last) return;
    getImages();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return imageList.isEmpty
        ? const Scaffold(
            extendBody: true,
            backgroundColor: Colors.blueGrey,
            body: Center(
              child: Text("No Images",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
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
                itemCount: imageList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Uint8List? image = await cropImage(imageList[index]);
                      Get.to(
                          () => Image_Post(
                                image: image,
                              ),
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.file(
                        File(imageList[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  Future<Uint8List?> cropImage(String? file) async {
    if (file != null) {
      var compressedImage = await compressImage(file, 35);
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: compressedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      return await croppedImage!.readAsBytes();
    } else {
      throw "Error";
    }
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);
    return result!;
  }
}
