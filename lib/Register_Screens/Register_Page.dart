import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:ik/Home_Screens/Home_Page.dart';
import 'package:ik/Login_Screens/Login_Page.dart';
import 'package:ik/Auth/Register_Auth.dart';
import 'package:ik/Register_Screens/Load_Images.dart';
import 'package:ik/ReusableWidgets.dart';
import 'package:ik/Templates/UserTemplate.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../User_Provider.dart';

class Register_Page extends StatefulWidget {
  Register_Page({Key? key, required this.data, this.image}) : super(key: key);
  Uint8List? image;
  final dynamic data;
  @override
  State<Register_Page> createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  final picker = ImagePicker();
  Uint8List? image;
  final key = GlobalKey<FormState>();
  TextEditingController fullName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController aadhar = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;
  IconData icon = Icons.cancel;

  setImage(Uint8List image) {
    setState(() {
      this.image = image;
    });
  }

  void storeDataLocally(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("username", username);
    UserProvider.setUsername(preferences.getString("username")!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullName.text = widget.data['name'];
    aadhar.text = widget.data['aadhar'];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  bottomSheet();
                                },
                                child: image == null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.black87,
                                        foregroundColor: Colors.green,
                                        radius:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        backgroundImage: const AssetImage(
                                            'assets/images/profile.jpg'),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.black87,
                                        foregroundColor: Colors.green,
                                        radius:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        backgroundImage: MemoryImage(image!),
                                      ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),

                        // Full Name Field
                        Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06,
                              right: MediaQuery.of(context).size.width * 0.06),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: "Cambria",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: fullName,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
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
                                color: const Color(0xFF978383).withOpacity(0.9),
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
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        // Username Field
                        Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06,
                              right: MediaQuery.of(context).size.width * 0.06),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: "Cambria",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (value) async {
                              bool data =
                                  await Register_Auth.searchUsername(value);
                              if (!mounted) {
                                return;
                              }
                              if (value.length >= 9 && value.length <= 16) {
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
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              suffixIcon: Icon(
                                icon,
                                color: icon == Icons.cancel
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              labelText: "Username",
                              labelStyle: TextStyle(
                                color: const Color(0xFF978383).withOpacity(0.9),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF1ECEC),
                            ),
                            validator: (user) {
                              if (user == null || user.isEmpty) {
                                return "Please Enter Your Username.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        // Password Field
                        Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06,
                              right: MediaQuery.of(context).size.width * 0.06),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: "Cambria",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: password,
                            obscureText: isObscure,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: isObscure
                                    ? Icon(
                                        Icons.visibility,
                                        color: Colors.deepPurple[300],
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Colors.deepPurple[300],
                                      ),
                                onPressed: () {
                                  setState(() {
                                    isObscure = isObscure ? false : true;
                                  });
                                },
                                color: Colors.purple,
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: const Color(0xFF978383).withOpacity(0.9),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF1ECEC),
                            ),
                            validator: (pass) {
                              if (pass == null || pass.isEmpty) {
                                return "Please Enter Your Password.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        // Full Name Field
                        Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06,
                              right: MediaQuery.of(context).size.width * 0.06),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: "Cambria",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black12,
                            ),
                            controller: aadhar,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              suffixIcon: Icon(
                                Icons.numbers,
                                color: Colors.deepPurple[300],
                              ),
                              labelText: "Aadhar Number",
                              labelStyle: TextStyle(
                                color: const Color(0xFF978383).withOpacity(0.9),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF1ECEC),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        Container(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () async {
                              if (key.currentState!.validate() &&
                                  icon == Icons.check_circle) {
                                if (!mounted) return;
                                setState(
                                  () {
                                    isLoading = true;
                                  },
                                );
                                String id = const Uuid().v1();
                                if (image != null) {
                                  String photoUrl =
                                      await Register_Auth.UploadProfileImage(
                                          image!, id);
                                  UserTemplate userData = UserTemplate(
                                    id: id,
                                    aadharNo: widget.data['aadhar'],
                                    username: username.text.trim(),
                                    password: password.text.trim(),
                                    photoUrl: photoUrl,
                                    Name: fullName.text.trim(),
                                    following: [],
                                    followers: [],
                                    imagePosts: [],
                                    videoPosts: [],
                                  );
                                  bool data = await Register_Auth.RegisterUser(
                                      userData);
                                  if (data) {
                                    storeDataLocally(username.text.trim());
                                    UserProvider.setUser(userData);
                                    Get.off(
                                      () =>
                                          Home_Page(data: username.text.trim()),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                      duration: const Duration(seconds: 1),
                                    );
                                    ReusableWidgets.Toast(
                                        "Regsitered Successfully", true);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    ReusableWidgets.Toast(
                                        "Error Occured on Registering Yourself. Try again Later",
                                        false);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } else {
                                  ReusableWidgets.Toast(
                                      "Please select an image.", false);
                                }
                              } else {
                                ReusableWidgets.Toast(
                                    "Please Enter Valid Username.", false);
                              }
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.001,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: "Cambria",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.off(
                                  () => const Login_Page(),
                                  transition: Transition.rightToLeftWithFade,
                                  duration: const Duration(seconds: 1),
                                );
                                username.clear();
                                password.clear();
                              },
                              child: Text(
                                "Click Here",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[300],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
