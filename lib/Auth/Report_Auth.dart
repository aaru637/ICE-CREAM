import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ik/Templates/Report_Template.dart';
import 'package:uuid/uuid.dart';

class Report_Auth {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> PostReport(Report_Template report) async {
    try {
      await firestore
          .collection("reports")
          .doc(report.UserId)
          .collection(report.PostId)
          .doc(report.ReportId)
          .set(report.toJson());
    } catch (e) {}
  }
}
