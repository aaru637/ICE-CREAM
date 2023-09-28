import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

class ReusableWidgets {
  static dynamic Toast(String message, bool messageType) {
    return Fluttertoast.showToast(
      msg: message,
      backgroundColor:
          messageType ?const Color(0xff00ff00) :  const Color(0xffff0000),
      textColor:
          messageType ? const Color(0xFF000000) : const Color(0xffffffff),
    );
  }
}
