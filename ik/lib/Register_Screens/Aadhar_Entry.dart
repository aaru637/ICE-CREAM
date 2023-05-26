import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ik/Register_Screens/Aadhar_Otp.dart';
import 'package:ik/Auth/Register_Auth.dart';
import 'package:ik/ReusableWidgets.dart';

class Aadhar_Entry extends StatefulWidget {
  const Aadhar_Entry({Key? key}) : super(key: key);

  @override
  State<Aadhar_Entry> createState() => _Aadhar_EntryState();
}

class _Aadhar_EntryState extends State<Aadhar_Entry> {
  TextEditingController aadharNo = TextEditingController();
  String aadhar = "";
  bool isLoading = false;
  final key = GlobalKey<FormState>();
  IconData icon = Icons.cancel;

  @override
  void dispose() {
    // TODO: implement dispose
    aadharNo.dispose();
    super.dispose();
  }

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/register.jpg",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),

                      // Aadhar No Field
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            right: MediaQuery.of(context).size.width * 0.06),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                            AadharInputFormat(),
                          ],
                          style: TextStyle(
                            fontFamily: "Cambria",
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) async {
                            List<String> data = value.split("\t\t").toList();
                            String sample = "";
                            for (String d in data) {
                              sample += d;
                            }
                            if (!mounted) {
                              return;
                            }
                            bool result =
                                await Register_Auth.searchAadhar(sample);
                            setState(() {
                              aadhar = sample;
                              if (aadhar.length == 12) {
                                if (result) {
                                  ReusableWidgets.Toast(
                                      "Aadhar Number exists.", false);
                                  setState(() {
                                    icon = Icons.cancel;
                                  });
                                } else {
                                  setState(() {
                                    icon = Icons.check_circle;
                                  });
                                }
                              } else {
                                icon = Icons.cancel;
                              }
                            });
                          },
                          controller: aadharNo,
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
                              icon,
                              color: icon == Icons.cancel
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            labelText: "Aadhar No",
                            labelStyle: TextStyle(
                              color: const Color(0xFF978383).withOpacity(0.9),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF1ECEC),
                          ),
                          validator: (user) {
                            if (user == null || user.isEmpty) {
                              return "Please Enter Your Aadhar No.";
                            } else if (user.length < 16) {
                              return "Aadhar No must be 12 digits.";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (key.currentState!.validate() &&
                                icon == Icons.check_circle) {
                              if (!mounted) {
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });
                              String data =
                                  await Register_Auth.requestOtp(aadhar);
                              if (data == "Error") {
                                setState(() {
                                  isLoading = false;
                                });
                                print(data);
                                ReusableWidgets.Toast(
                                    "Please Try again Later", false);
                              } else if (data == "Verification Failed") {
                                setState(() {
                                  isLoading = false;
                                });
                                ReusableWidgets.Toast(
                                    "Verification Failed. Try again Later.",
                                    false);
                              } else {
                                ReusableWidgets.Toast(
                                    "OTP Sent to the Registered Mobile Number.",
                                    true);
                                print(data);
                                Get.to(() => Aadhar_Otp(clientId: data),
                                    transition: Transition.rightToLeftWithFade,
                                    duration: const Duration(seconds: 1));
                                setState(() {
                                  isLoading = false;
                                });
                                aadharNo.clear();
                              }
                            } else {
                              ReusableWidgets.Toast(
                                  "Please Enter Different Aadhar number.",
                                  false);
                            }
                          },
                          child: Text(
                            "Verify",
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
}

class AadharInputFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String data = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < data.length; i++) {
      buffer.write(data[i]);
      int index = i + 1;
      if (index % 4 == 0 && data.length != index) {
        buffer.write("\t\t");
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}
