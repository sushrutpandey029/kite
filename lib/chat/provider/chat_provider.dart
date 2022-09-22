import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/chat/model/chat_user_model.dart';
import 'package:kite/chat/model/send_message_model.dart';
import 'package:kite/database/hive_models/auth_hive_model.dart';
import 'package:kite/database/hive_models/boxes.dart';
import 'package:kite/database/repository/message_hive_repo.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:provider/provider.dart';

import '../model/chat_model.dart';
import '../repository/chat_repo.dart';
import '../ui/screens/chat_screen.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo _chatRepo = ChatRepo();
  List<ChatUserModel> chatUsersList = [];
  bool isLoading = false;
  ChatUserModel? selectedUser;
  List<ChatModel> finalChatList = [];
  final MessageHiveRepo _messageHiveRepo = MessageHiveRepo();
  // final myBox = Boxes.getAuthHive();
  // AuthHiveModel? authPh = AuthHiveModel()..pNumber = '';

  // Future<void> initalise(BuildContext context) {
  //   authPh = myBox.get('authPh');

  //   return context.read<AuthProvider>().getUser(authPh!.pNumber);
  // }

  void fetchChatUsersLocal(BuildContext context) {
    isLoading = true;

    // initalise(context).then((value) {
    // userModel = context.read<AuthProvider>().authUserModel;

    String userId = context.read<AuthProvider>().authUserModel!.id;
    log(userId);
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
    // });
    isLoading = false;
  }

  Future<void> fetchChatUsers(BuildContext context) async {
    List<ChatModel>? chatList;
    isLoading = true;

    fetchChatUsersLocal(context);
    // _messageHiveRepo.clearBox();
    // notifyListeners();
    // initalise(context).then((value) async {
    String userId = context.read<AuthProvider>().authUserModel!.id;
    chatList = await _chatRepo.fetchChatBySenderId(userId);
    chatList.addAll(await _chatRepo.fetchChatByReceiverId(userId));
    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });
    List<ChatUserModel> userList = [];
    List<String> userIdList = [];
    await _messageHiveRepo.addMessages(chatList, true);
    // _messageHiveRepo.clearBox();

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
    // });

    isLoading = false;
    notifyListeners();
  }

  void selectUser(
      int index, BuildContext context, bool newChat, AuthUserModel userModela) {
    if (newChat) {
      selectedUser = ChatUserModel(
        userId: userModela.id,
        userRegNo: userModela.userRegNo,
        userName: userModela.userName,
        userPhoneNo: userModela.userPhoneNumber,
        lastMessage: '',
        lastMessageTime: DateTime.now(),
        unreadMessagesCount: 0,
      );
      chatUsersList.add(selectedUser!);
    } else {
      selectedUser = chatUsersList.elementAt(index);
    }
    notifyListeners();
    finalChatList.clear();
    fetchChat(context);
    customNavigator(
        context,
        ChatScreen(
          isGroupChat: false,
        ));
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

  Future<void> sendAudio(SendChatModel chatModel, BuildContext context) async {
    try {
      _chatRepo.sendAudio(
          chatModel.userSenderId,
          chatModel.userSenderRegNo,
          chatModel.userSenderNumber,
          chatModel.userSenderName,
          chatModel.userReceiverId,
          chatModel.userReceiverRegNo,
          chatModel.userReceiverNumber,
          chatModel.userReceiverName,
          chatModel.audioMessage);
      // _messageHiveRepo
      //     .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      // fetchChatUsersLocal(context);
      // fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);
      // notifyListeners();
      // await _chatRepo.sendMessage(chatModel);
      // notifyListeners();
      // await fetchChatUsers(context);
      // await fetchChat(context);
      // notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendImage(SendChatModel chatModel, BuildContext context) async {
    try {
      _chatRepo.sendImage(
          chatModel.userSenderId,
          chatModel.userSenderRegNo,
          chatModel.userSenderNumber,
          chatModel.userSenderName,
          chatModel.userReceiverId,
          chatModel.userReceiverRegNo,
          chatModel.userReceiverNumber,
          chatModel.userReceiverName,
          chatModel.imageMessage);
      // _messageHiveRepo
      //     .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      // fetchChatUsersLocal(context);
      // fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);
      // notifyListeners();
      // await _chatRepo.sendMessage(chatModel);
      // notifyListeners();
      // await fetchChatUsers(context);
      // await fetchChat(context);
      // notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }
}
