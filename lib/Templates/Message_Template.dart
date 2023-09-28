class Message_Template {
  final String FromUserId;
  final String ToUserId;
  final String FromUsername;
  final String ToUsername;
  final String FromPhotoUrl;
  final String ToPhotoUrl;
  final String LastMessage;

  const Message_Template(
      {required this.FromUserId,
      required this.ToUserId,
      required this.FromUsername,
      required this.ToUsername,
      required this.FromPhotoUrl,
      required this.ToPhotoUrl,
      required this.LastMessage});

  Map<String, dynamic> toJson() => {
        "FromUserId": FromUserId,
        "ToUserId": ToUserId,
        "FromUsername": FromUsername,
        "ToUsername": ToUsername,
        "FromPhotoUrl": FromPhotoUrl,
        "ToPhotoUrl": ToPhotoUrl,
        "LastMessage": LastMessage,
      };

  factory Message_Template.fromJson(Map<String, dynamic> json) =>
      Message_Template(
          FromUserId: json['FromUserId'],
          ToUserId: json['ToUserId'],
          FromUsername: json['FromUsername'],
          ToUsername: json['ToUsername'],
          FromPhotoUrl: json['FromPhotoUrl'],
          ToPhotoUrl: json['ToPhotoUrl'],
          LastMessage: json['LastMessage']);
}
