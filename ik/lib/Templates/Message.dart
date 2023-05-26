class Message {
  final String ToUserId;
  final String ToUsername;
  final String ToPhotoUrl;
  final String MessageId;
  final String MessageType;
  final String MessageContent;
  final String ImageData;
  final String VideoData;
  final DateTime DatePublished;

  const Message({
      required this.ToUserId,
      required this.ToUsername,
      required this.ToPhotoUrl,
      required this.MessageId,
      required this.MessageType,
      required this.MessageContent,
      required this.ImageData,
      required this.VideoData,
      required this.DatePublished});

  Map<String, dynamic> tojson() => {
        "ToUserId": ToUserId,
        "ToUsername": ToUsername,
        "ToPhotoUrl": ToPhotoUrl,
        "MessageId": MessageId,
        "MessageType": MessageType,
        "MessageContent": MessageContent,
        "ImageData": ImageData,
        "VideoData": VideoData,
        "DatePublished": DatePublished,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      ToUserId: json['ToUserId'],
      ToUsername: json['ToUsername'],
      ToPhotoUrl: json['ToPhotoUrl'],
      MessageId: json['MessageId'],
      MessageType: json['MessageType'],
      MessageContent: json['MessageContent'],
      ImageData: json['ImageData'],
      VideoData: json['VideoData'],
      DatePublished: json['DatePublished']);
}
