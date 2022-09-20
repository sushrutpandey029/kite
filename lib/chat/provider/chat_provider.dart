import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/chat/model/chat_user_model.dart';
import 'package:kite/chat/model/send_message_model.dart';
import 'package:kite/database/repository/message_hive_repo.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../model/chat_model.dart';
import '../repository/chat_repo.dart';
import '../ui/screens/chat_screen.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo _chatRepo = ChatRepo();
  List<ChatUserModel> chatUsersList = [];
  ChatUserModel? selectedUser;
  List<ChatModel> finalChatList = [];
  final MessageHiveRepo _messageHiveRepo = MessageHiveRepo();

  void fetchChatUsersLocal(BuildContext context) {
    String userId = context.read<AuthProvider>().authUserModel!.id;
    List<ChatModel> chatList = _messageHiveRepo.fetchMessages();
    List<ChatUserModel> userList = [];
    List<String> userIdList = [];

    for (ChatModel chat in chatList) {
      if (chat.senderId == userId) {
        if (userIdList.contains(chat.receiverId)) {
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessage = chat.textMasseg;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .userName = chat.receiverName;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessageTime = chat.datetime;
          int unReadMessageCount = userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;
          //todo: check for unread message count
          print(unReadMessageCount);
        } else {
          userIdList.add(chat.receiverId);
          userList.add(ChatUserModel(
            userId: chat.receiverId,
            userRegNo: chat.receiverRegNo,
            userName: chat.receiverName,
            userPhoneNo: chat.receiverNumber,
            lastMessage: chat.textMasseg,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));

          //todo: check for unread message count
        }
      } else {
        if (userIdList.contains(chat.senderId)) {
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessage = chat.textMasseg;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .userName = chat.senderName;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessageTime = chat.datetime;
          int unReadMessageCount = userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;
          //todo: check for unread message count

        } else {
          userIdList.add(chat.senderId);
          userList.add(ChatUserModel(
            userId: chat.senderId,
            userRegNo: chat.senderRegNo,
            userName: chat.senderName,
            userPhoneNo: chat.senderNumber,
            lastMessage: chat.textMasseg,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));
          //todo: check for unread message count

        }
      }
    }

    userList.sort((a, b) {
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });

    chatUsersList = userList;
    log(chatUsersList.toString());
    notifyListeners();
  }

  Future<void> fetchChatUsers(BuildContext context) async {
    fetchChatUsersLocal(context);
    _messageHiveRepo.clearBox();
    notifyListeners();
    String userId = context.read<AuthProvider>().authUserModel!.id;
    List<ChatUserModel> userList = [];
    List<String> userIdList = [];
    List<ChatModel> chatList = await _chatRepo.fetchChatBySenderId(userId);

    chatList.addAll(await _chatRepo.fetchChatByReceiverId(userId));

    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });

    // _messageHiveRepo.clearBox();

    _messageHiveRepo.addMessages(chatList, true);
    // for (ChatModel element in chatList) {
    //   _messageHiveRepo.addMessages(element);
    // }
    // log ( _messageHiveRepo.fetchMessages().toString());

    for (ChatModel chat in chatList) {
      if (chat.senderId == userId) {
        if (userIdList.contains(chat.receiverId)) {
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessage = chat.textMasseg;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .userName = chat.receiverName;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessageTime = chat.datetime;
          int unReadMessageCount = userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;

          //todo: check for unread message count

        } else {
          userIdList.add(chat.receiverId);
          userList.add(ChatUserModel(
            userId: chat.receiverId,
            userRegNo: chat.receiverRegNo,
            userName: chat.receiverName,
            userPhoneNo: chat.receiverNumber,
            lastMessage: chat.textMasseg,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));
          //todo: check for unread message count
        }
      } else {
        if (userIdList.contains(chat.senderId)) {
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessage = chat.textMasseg;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .userName = chat.senderName;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessageTime = chat.datetime;

          int unReadMessageCount = userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;
          //todo: check for unread message count

        } else {
          userIdList.add(chat.senderId);
          userList.add(ChatUserModel(
            userId: chat.senderId,
            userRegNo: chat.senderRegNo,
            userName: chat.senderName,
            userPhoneNo: chat.senderNumber,
            lastMessage: chat.textMasseg,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));
          //todo: check for unread message count

        }
      }
    }

    userList.sort((a, b) {
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });

    chatUsersList = userList;
    notifyListeners();
  }

  void selectUser(int index, BuildContext context) {
    selectedUser = chatUsersList.elementAt(index);
    notifyListeners();
    finalChatList.clear();
    fetchChat(context);
    customNavigator(
      context,
      ChatScreen(
        isGroupChat: false,
      ),
    );
  }

  void fetchChatLocal(String senderId, String receiverId) {
    List<ChatModel> chatList = _messageHiveRepo.fetchById(senderId, receiverId);
    chatList.addAll(_messageHiveRepo.fetchById(receiverId, senderId));
    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });
    finalChatList = chatList;
    log(finalChatList.toString());
    notifyListeners();
  }

  Future<void> fetchChat(BuildContext context) async {
    print('fetch chat');
    String userId = context.read<AuthProvider>().authUserModel!.id;
    fetchChatLocal(userId, selectedUser!.userId);
    List<ChatModel> chatList = [];
    chatList.addAll(await _chatRepo.fetchChatBySenderAndReceiver(
        userId, selectedUser!.userId));
    chatList.addAll(await _chatRepo.fetchChatBySenderAndReceiver(
        selectedUser!.userId, userId));

    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });

    finalChatList = chatList;
    notifyListeners();
  }

  Future<void> sendMessage(
      SendChatModel chatModel, BuildContext context) async {
    _messageHiveRepo.addMessages([ChatModel.fromMap(chatModel.toMap())], false);
    fetchChatUsersLocal(context);
    fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);
    notifyListeners();
    await _chatRepo.sendMessage(chatModel);
    notifyListeners();
    await fetchChatUsers(context);
    await fetchChat(context);
    notifyListeners();
  }

  Future<void> sendAudio(
      String user_sender_id,
      String user_sender_reg_no,
      String user_sender_number,
      String user_senderr_name,
      String user_receiver_id,
      String user_receiver_reg_no,
      String user_receiver_number,
      String user_receiver_name,
      String audio) async {
    try {
      _chatRepo.sendAudio(
          user_sender_id,
          user_sender_reg_no,
          user_sender_number,
          user_senderr_name,
          user_receiver_id,
          user_receiver_reg_no,
          user_receiver_number,
          user_receiver_name,
          audio);
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }
}
