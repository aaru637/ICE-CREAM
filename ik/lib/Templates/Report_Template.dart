class Report_Template {
  final String UserId;
  final String PostId;
  final String ReportId;
  final String Username;
  final String Report;
  final DateTime DatePublished;

  const Report_Template({
    required this.UserId,
    required this.PostId,
    required this.ReportId,
    required this.Username,
    required this.Report,
    required this.DatePublished,
  });

  Map<String, dynamic> toJson() => {
        "UserId": UserId,
        "PostId": PostId,
    "ReportId" : ReportId,
        "Username": Username,
        "Report": Report,
        "DatePublished": DatePublished,
      };

  factory Report_Template.fromJson(Map<String, dynamic> json) =>
      Report_Template(
          UserId: json['UserId'],
          PostId: json['PostId'],
          ReportId : json['ReportId'],
          Username: json['Username'],
          Report: json['Report'],
          DatePublished: json['DatePublished']);
}
