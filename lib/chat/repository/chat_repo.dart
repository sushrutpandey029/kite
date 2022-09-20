import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kite/chat/model/chat_model.dart';
import 'package:kite/chat/model/send_message_model.dart';
import 'package:kite/shared/constants/url_constants.dart';

class ChatRepo {
  final String _chatApi = '$baseUrl/Kiteapi_controller';

  Future<List<ChatModel>> fetchChatBySenderId(String senderId) async {
    List<ChatModel> list = [];
    String url = '$_chatApi/show_msg_senderid';

    try {
      Response response = await Dio().post(url, data: {"sender_id": senderId});
      if (response.data['status'] == 1) {
        for (Map<String, dynamic> map in response.data['txt_msg']) {
          ChatModel chat = ChatModel.fromMap(map);
          list.add(chat);
        }
      }
      return list;
    } on DioError {
      rethrow;
    }
  }

  Future<List<ChatModel>> fetchChatByReceiverId(String receiverId) async {
    List<ChatModel> list = [];
    String url = '$_chatApi/show_msg_receiverid';

    try {
      Response response =
          await Dio().post(url, data: {"receiver_id": receiverId});
      if (response.data['status'] == 1) {
        for (Map<String, dynamic> map in response.data['txt_msg']) {
          ChatModel chat = ChatModel.fromMap(map);
          list.add(chat);
        }
      }
      return list;
    } on DioError {
      rethrow;
    }
  }

  Future<List<ChatModel>> fetchChatBySenderAndReceiver(
      String senderId, String receiverId) async {
    List<ChatModel> list = [];
    String url = '$_chatApi/show_msg_by_sr';

    try {
      Response response = await Dio()
          .post(url, data: {"sender_id": senderId, "receiver_id": receiverId});
      if (response.data['status'] == 1) {
        for (Map<String, dynamic> map in response.data['txt_msg']) {
          ChatModel chat = ChatModel.fromMap(map);
          list.add(chat);
        }
      }
      return list;
    } on DioError {
      rethrow;
    }
  }

  Future<void> sendMessage(SendChatModel chatModel) async {
    String url = '$_chatApi/userone_reply_usertwo';
    try {
      Response response = await Dio().post(url, data: chatModel.toMap());
      log(response.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<bool> sendAudio(
      String user_sender_id,
      String user_sender_reg_no,
      String user_sender_number,
      String user_senderr_name,
      String user_receiver_id,
      String user_receiver_reg_no,
      String user_receiver_number,
      String user_receiver_name,
      String audio) async {
    String url = '$_chatApi/send_audio_mgs';

    String audioName = audio.split('/').last;

    try {
      FormData formData = FormData.fromMap({
        // 'firebase_id': user.firebaseId,
        'user_sender_id': user_sender_id,
        'user_sender_reg_no': user_sender_reg_no,
        'user_sender_number': user_receiver_number,
        'user_sender_name': user_senderr_name,
        'user_receiver_id': user_receiver_id,
        'user_receiver_reg_no': user_sender_reg_no,
        'user_receiver_number': user_receiver_number,
        'user_receiver_name': user_receiver_name,
        'audio': await MultipartFile.fromFile(audio, filename: audioName)
      });
      Response response = await Dio().post(url,
          data: formData,
          options: Options(
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
              headers: {'Connection': 'keep-alive'}));
      print(response.data);

      return response.data['status'] == 1;
    } on DioError {
      rethrow;
    }
  }
}
