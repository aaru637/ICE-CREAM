import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Register_Screens/Load_Images.dart';
import 'package:ik/Templates/UserTemplate.dart';
import 'package:ik/User_Provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import '../Auth/Register_Auth.dart';
import '../ReusableWidgets.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({Key? key}) : super(key: key);

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  final picker = ImagePicker();
  Uint8List? image;
  final key = GlobalKey<FormState>();
  TextEditingController fullName = TextEditingController();
  TextEditingController username = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;
  IconData icon = Icons.cancel;

  UserTemplate? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = UserProvider.getUser();
    fullName.text = user!.Name;
    username.text = user!.username;
  }

  setImage(Uint8List image) {
    setState(() {
      this.image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
        child: getAppBar(),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: key,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  // Full Name Field
                                  Container(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.1),
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontFamily: "Cambria",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      controller: fullName,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          Icons.person,
                                          color: Colors.deepPurple[300],
                                        ),
                                        labelText: "Full Name",
                                        labelStyle: TextStyle(
                                          color: const Color(0xFF978383)
                                              .withOpacity(0.9),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1ECEC),
                                      ),
                                      validator: (user) {
                                        if (user == null || user.isEmpty) {
                                          return "Please Enter Your Full Name.";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),

                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),

                                  // Username Field
                                  Container(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.06),
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontFamily: "Cambria",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onChanged: (value) async {
                                        bool data =
                                            await Register_Auth.searchUsername(
                                                value);
                                        if (!mounted) {
                                          return;
                                        }
                                        if (value.length >= 9 &&
                                            value.length <= 16) {
                                          if (data) {
                                            ReusableWidgets.Toast(
                                                "Username exists.", false);
                                            setState(() {
                                              icon = Icons.cancel;
                                            });
                                          } else {
                                            setState(() {
                                              icon = Icons.check_circle;
                                            });
                                          }
                                        } else {
                                          ReusableWidgets.Toast(
                                              "Username must be the length of 9 to 16 characters.",
                                              false);
                                          setState(() {
                                            icon = Icons.cancel;
                                          });
                                        }
                                      },
                                      controller: username,
                                      readOnly: true,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        suffixIcon: const Icon(Icons.person),
                                        labelText: "Username",
                                        labelStyle: TextStyle(
                                          color: const Color(0xFF978383)
                                              .withOpacity(0.9),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1ECEC),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),

                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.deepPurple[300],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      onPressed: () async {
                                        if (key.currentState!.validate()) {
                                          if (!mounted) return;
                                          setState(
                                            () {
                                              isLoading = true;
                                            },
                                          );
                                          if (image != null) {
                                            String photoUrl =
                                                await Register_Auth
                                                    .UploadProfileImage(
                                                        image!,
                                                        UserProvider.getUser()!
                                                            .id);
                                            await Register_Auth.Edit_Profile(
                                                fullName.text.trim(), photoUrl);
                                            UserTemplate user =
                                                UserProvider.getUser()!;
                                            UserTemplate user1 = UserTemplate(
                                                id: user.id,
                                                aadharNo: user.aadharNo,
                                                username: user.username,
                                                password: user.password,
                                                photoUrl: photoUrl,
                                                Name: fullName.text.trim(),
                                                followers: user.followers,
                                                following: user.following,
                                                imagePosts: user.imagePosts,
                                                videoPosts: user.videoPosts);
                                            UserProvider.setUser(user1);
                                          } else {
                                            await Register_Auth.Edit_Profile(
                                                fullName.text.trim(),
                                                UserProvider.getUser()!
                                                    .photoUrl);
                                          }
                                          ReusableWidgets.Toast(
                                              "Profile Updated Successfully",
                                              true);
                                          Navigator.of(context).pop();
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.001,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFE1F6F4),
      iconTheme: const IconThemeData(color: Colors.black),
      flexibleSpace: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.green,
                          radius: MediaQuery.of(context).size.width / 6,
                          backgroundImage: NetworkImage(user!.photoUrl),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.green,
                          radius: MediaQuery.of(context).size.width / 6,
                          backgroundImage: MemoryImage(image!),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TextButton(
              onPressed: () {
                bottomSheet();
              },
              child: Text(
                "Change Profile",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottomSheet() {
    var size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        barrierColor: Colors.white24,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20)),
            height: size.height * 0.12,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final status =
                                await Permission.camera.status.isGranted;
                            if (status) {
                              Uint8List currentImage =
                                  await pickImageFromCamera();
                              setState(() {
                                image = currentImage;
                              });
                            } else {
                              await Permission.camera.request();
                            }
                          },
                          icon: Icon(
                            Feather.camera,
                            color: Colors.white,
                            size: size.width * 0.07,
                          ),
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            image = await Get.to(
                              () => const Load_Images(),
                              transition: Transition.downToUp,
                              duration: const Duration(seconds: 1),
                            );
                            setState(() {
                              image = image;
                            });
                          },
                          icon: Icon(
                            Feather.image,
                            color: Colors.white,
                            size: size.width * 0.07,
                          ),
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  pickImageFromCamera() async {
    XFile? file =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (file != null) {
      var compressedImage = await compressImage(file.path, 35);
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
    }
    ReusableWidgets.Toast("No Image Selected", false);
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);
    return result!;
  }
}
