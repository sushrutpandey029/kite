// To parse this JSON data, do
//
//     final sendChatModel = sendChatModelFromMap(jsonString);

import 'dart:convert';

SendChatModel sendChatModelFromMap(String str) =>
    SendChatModel.fromMap(json.decode(str));

String sendChatModelToMap(SendChatModel data) => json.encode(data.toMap());

class SendChatModel {
  String userSenderId;
  String userSenderRegNo;
  String userSenderNumber;
  String userSenderName;
  String userReceiverId;
  String userReceiverRegNo;
  String userReceiverNumber;
  String userReceiverName;
  String textMasseg;
  String imageMessage;
  String audioMessage;

  SendChatModel({
    required this.userSenderId,
    required this.userSenderRegNo,
    required this.userSenderNumber,
    required this.userSenderName,
    required this.userReceiverId,
    required this.userReceiverRegNo,
    required this.userReceiverNumber,
    required this.userReceiverName,
    required this.textMasseg,
    required this.imageMessage,
    required this.audioMessage,
  });

  factory SendChatModel.fromMap(Map<String, dynamic> json) => SendChatModel(
        userSenderId: json["user_sender_id"],
        userSenderRegNo: json["user_sender_reg_no"],
        userSenderNumber: json["user_sender_number"],
        userSenderName: json["user_sender_name"],
        userReceiverId: json["user_receiver_id"],
        userReceiverRegNo: json["user_receiver_reg_no"],
        userReceiverNumber: json["user_receiver_number"],
        userReceiverName: json["user_receiver_name"],
        textMasseg: json["text_masseg"],
        imageMessage: json["file_msg"],
        audioMessage: json["voice_record_msg"],
      );

  Map<String, dynamic> toMap() => {
        "user_sender_id": userSenderId,
        "user_sender_reg_no": userSenderRegNo,
        "user_sender_number": userSenderNumber,
        "user_sender_name": userSenderName,
        "user_receiver_id": userReceiverId,
        "user_receiver_reg_no": userReceiverRegNo,
        "user_receiver_number": userReceiverNumber,
        "user_receiver_name": userReceiverName,
        "text_masseg": textMasseg,
        "file_msg": imageMessage,
        "voice_record_msg": audioMessage,
      };

  @override
  String toString() {
    return 'SendChatModel(userSenderId: $userSenderId, userSenderRegNo: $userSenderRegNo, userSenderNumber: $userSenderNumber, userSenderName: $userSenderName, userReceiverId: $userReceiverId, userReceiverRegNo: $userReceiverRegNo, userReceiverNumber: $userReceiverNumber, userReceiverName: $userReceiverName, textMasseg: $textMasseg, imageMessage: $imageMessage, audioMessage: $audioMessage)';
  }
}
