import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ik/Register_Screens/Aadhar_Entry.dart';
import 'package:ik/Auth/Register_Auth.dart';
import 'package:ik/ReusableWidgets.dart';

import 'Register_Page.dart';

class Aadhar_Otp extends StatefulWidget {
  const Aadhar_Otp({Key? key, required this.clientId}) : super(key: key);

  final String? clientId;

  @override
  State<Aadhar_Otp> createState() => _Aadhar_OtpState();
}

class _Aadhar_OtpState extends State<Aadhar_Otp> {
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();
  bool isLoading = false;
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Scaffold(
        backgroundColor: isLoading ? const Color(0x88ffffff) : Colors.white,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(backgroundColor: Colors.white),
              )
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Image.asset(
                        "assets/images/mobile_otp.jpg",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            otpField(
                                first: true, last: false, controller: otp1),
                            otpField(
                                first: false, last: false, controller: otp2),
                            otpField(
                                first: false, last: false, controller: otp3),
                            otpField(
                                first: false, last: false, controller: otp4),
                            otpField(
                                first: false, last: false, controller: otp5),
                            otpField(
                                first: false, last: true, controller: otp6),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: TextButton(
                          onPressed: () {
                            Get.off(() => const Aadhar_Entry(),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(seconds: 1));
                          },
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.deepPurple[300]),
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
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              if (!mounted) {
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });
                              String otp = otp1.text +
                                  otp2.text +
                                  otp3.text +
                                  otp4.text +
                                  otp5.text +
                                  otp6.text;
                              print(otp.length);
                              if (otp.length == 6) {
                                dynamic data = await Register_Auth.submitOtp(
                                    widget.clientId, otp);
                                if (data != 'Error') {
                                  Get.off(
                                    () => Register_Page(
                                      data: data,
                                    ),
                                    transition: Transition.rightToLeftWithFade,
                                    duration: const Duration(seconds: 1),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  ReusableWidgets.Toast(
                                      "Please Try again Later", false);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              } else {
                                ReusableWidgets.Toast(
                                    "Please Enter all 6 Digits in OTP.", false);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Submit",
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  otpField(
      {required bool first, last, required TextEditingController controller}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.14,
      width: MediaQuery.of(context).size.width * 0.14,
      child: AspectRatio(
        aspectRatio: 0.7,
        child: TextField(
          autofocus: true,
          controller: controller,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.07),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(width: 2, color: Colors.purpleAccent),
            ),
          ),
        ),
      ),
    );
  }
}
