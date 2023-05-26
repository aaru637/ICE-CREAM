import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ik/Auth/Login_Auth.dart';
import 'package:ik/Home_Screens/Home_Page.dart';
import 'package:ik/ReusableWidgets.dart';
import 'package:ik/Templates/UserTemplate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Register_Screens/Aadhar_Entry.dart';
import '../User_Provider.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final key = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;

  void storeDataLocally(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("username", username);
    UserProvider.setUsername(preferences.getString("username")!);
    UserTemplate? user = await Login_Auth.getUser(username);
    UserProvider.setUser(user!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    username.dispose();
    password.dispose();
    super.dispose();
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
                        Image.asset(
                          "assets/images/login.jpg",
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height / 2.8,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Welcome Back 👋",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[300]),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
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
                                Icons.person,
                                color: Colors.deepPurple[300],
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
                              if (key.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                dynamic data = await Login_Auth.checkLogin(
                                    username.text.trim(), password.text.trim());
                                if (data[0] && data[1]) {
                                  storeDataLocally(username.text.trim());
                                  Get.off(
                                    () => Home_Page(data: username.text.trim()),
                                    transition: Transition.rightToLeftWithFade,
                                    duration: const Duration(seconds: 1),
                                  );
                                  ReusableWidgets.Toast(
                                      "Logged in Successfully", true);
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else if (data[0] && !data[1]) {
                                  ReusableWidgets.Toast(
                                      "Password is Incorrect", false);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  password.clear();
                                } else {
                                  ReusableWidgets.Toast(
                                      "You don't have an account.", false);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Text(
                              "Log In",
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
                              "If you are not Registered with us",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontFamily: "Cambria",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.off(
                                  () => const Aadhar_Entry(),
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
                                      MediaQuery.of(context).size.width * 0.04,
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
}
