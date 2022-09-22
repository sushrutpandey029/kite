import 'dart:convert';

ChatModel chatModelFromMap(String str) => ChatModel.fromMap(json.decode(str));

String chatModelToMap(ChatModel data) => json.encode(data.toMap());

class ChatModel {
  ChatModel({
    required this.id,
    required this.senderId,
    required this.senderRegNo,
    required this.senderNumber,
    required this.senderName,
    required this.receiverId,
    required this.receiverRegNo,
    required this.receiverNumber,
    required this.receiverName,
    required this.textMasseg,
    required this.datetime,
    required this.massageStatus,
    required this.imageMessage,
    required this.audioMessage,
  });

  String id;
  String senderId;
  String senderRegNo;
  String senderNumber;
  String senderName;
  String receiverId;
  String receiverRegNo;
  String receiverNumber;
  String receiverName;
  String textMasseg;
  DateTime datetime;
  String massageStatus;
  String audioMessage;
  String imageMessage;

  factory ChatModel.fromMap(Map<String, dynamic> json) => ChatModel(
        id: json["id"] ?? '',
        senderId: json["sender_id"] ?? '',
        senderRegNo: json["sender_reg_no"] ?? '',
        senderNumber: json["sender_number"] ?? '',
        senderName: json["sender_name"] ?? '',
        receiverId: json["receiver_id"] ?? '',
        receiverRegNo: json["receiver_reg_no"] ?? '',
        receiverNumber: json["receiver_number"] ?? '',
        receiverName: json["receiver_name"] ?? '',
        textMasseg: json["text_masseg"] ?? '',
        datetime: DateTime.parse(
            json["datetime"] ?? DateTime.now().toIso8601String()),
        massageStatus: json["massage_status"] ?? '',
        imageMessage: json["file_msg"] ?? '',
        audioMessage: json["voice_record_msg"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sender_id": senderId,
        "sender_reg_no": senderRegNo,
        "sender_number": senderNumber,
        "sender_name": senderName,
        "receiver_id": receiverId,
        "receiver_reg_no": receiverRegNo,
        "receiver_number": receiverNumber,
        "receiver_name": receiverName,
        "text_masseg": textMasseg,
        "datetime": datetime.toIso8601String(),
        "massage_status": massageStatus,
        "file_msg": imageMessage,
        "voice_record_msg": audioMessage,
      };

  @override
  String toString() {
    return 'ChatModel(id: $id, senderId: $senderId, senderRegNo: $senderRegNo, senderNumber: $senderNumber, senderName: $senderName, receiverId: $receiverId, receiverRegNo: $receiverRegNo, receiverNumber: $receiverNumber, receiverName: $receiverName, textMasseg: $textMasseg, datetime: $datetime, massageStatus: $massageStatus, imageMessage: $imageMessage, audioMessage: $audioMessage)';
  }
}
