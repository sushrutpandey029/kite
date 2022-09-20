import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kite/chat/ui/widgets/message_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../util/custom_navigation.dart';
import '../../model/send_message_model.dart';
import 'chat_profile_screen.dart';

enum MenuItem {
  item1,
  item2,
  item3,
  item4,
  item5,
  item6,
  item7,
}

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.isGroupChat}) : super(key: key);
  bool isGroupChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final recorder = FlutterSoundRecorder();

  String audio = '';

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    print(await recorder.stopRecorder());
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    audio = path;
    print('recorded audio:$path');
  }

  Future initRecorder() async {
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getMicrophonePermission();
    if (permissionStatus == PermissionStatus.granted) {
      await recorder.openRecorder();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.request();
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {}
  }

  String? imagePath;
  bool haveText = false;
  final TextEditingController _messageController = TextEditingController();

  final ChatProvider _chatProvider = ChatProvider();

  Future<void> _setBackground(bool isCamera) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = isCamera
        ? await picker.pickImage(source: ImageSource.camera)
        : await picker.pickImage(source: ImageSource.gallery);
    imagePath = xFile?.path;
    setState(() {});
  }

  void reloadMessage() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        context.read<ChatProvider>().fetchChat(context);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _messageController.addListener(() {
      if (_messageController.text == '') {
        setState(() {
          haveText = false;
        });
      } else {
        setState(() {
          haveText = true;
        });
      }
    });
    reloadMessage();
    super.initState();
    initRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      (imagePath != null)
          ? Image.asset(
              imagePath!,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            )
          : const SizedBox(),
      Scaffold(
        backgroundColor:
            (imagePath != null) ? Colors.transparent : Colors.white,
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Consumer<ChatProvider>(builder: (context, value, widget) {
            return InkWell(
              onTap: () {
                customNavigator(context, const ChatProfileScreen());
              },
              child: Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.selectedUser!.userName,
                        style: whiteText1,
                      ),
                      Text(
                        'Online..',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
            PopupMenuButton<MenuItem>(
                onSelected: (value) {
                  if (value == MenuItem.item1) {}
                  if (value == MenuItem.item2) {}
                  if (value == MenuItem.item3) {}
                  if (value == MenuItem.item4) {}
                  if (value == MenuItem.item5) {}
                  if (value == MenuItem.item6) {
                    _setBackground(false);
                    setState(() {});
                  }
                  if (value == MenuItem.item7) {}
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text('View contact'),
                      ),
                      const PopupMenuItem(
                        child: Text('Media, links and docs'),
                      ),
                      const PopupMenuItem(
                        child: Text('Search'),
                      ),
                      const PopupMenuItem(
                        child: Text('mute notification'),
                      ),
                      const PopupMenuItem(
                        child: Text('Disappearing messages'),
                      ),
                      const PopupMenuItem(
                        value: MenuItem.item6,
                        child: Text('Wallpaper'),
                      ),
                      const PopupMenuItem(
                        child: Text('More'),
                      ),
                    ])
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: gradient1),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Consumer<ChatProvider>(builder: (context, value, widget) {
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        // controller: _scrollController,
                        reverse: true,
                        shrinkWrap: true,
                        dragStartBehavior: DragStartBehavior.down,
                        itemCount: value.finalChatList.length,
                        itemBuilder: ((context, index) {
                          index = value.finalChatList.length - index - 1;
                          return MessageTileWidget(
                              message: value.finalChatList
                                  .elementAt(index)
                                  .textMasseg,
                              time: DateFormat.jm().format(value.finalChatList
                                  .elementAt(index)
                                  .datetime),
                              isByUser: value.finalChatList
                                      .elementAt(index)
                                      .senderId ==
                                  context
                                      .read<AuthProvider>()
                                      .authUserModel!
                                      .id,
                              isContinue: index == 0 ||
                                  value.finalChatList
                                          .elementAt(index - 1)
                                          .senderId ==
                                      value.finalChatList
                                          .elementAt(index)
                                          .senderId);
                        }))),
                Container(
                  color: Colors.transparent,
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      elevation: 10,
                      color: const Color.fromARGB(255, 210, 210, 210),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.emoji_emotions_outlined)),
                          SizedBox(
                            width: haveText ? 51.w : 43.w,
                            child: TextField(
                              maxLines: 4,
                              minLines: 1,
                              controller: _messageController,
                              decoration: const InputDecoration(
                                  hintText: 'Start Typing...',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.attach_file)),
                          if (!haveText)
                            IconButton(
                              onPressed: () async {
                                if (recorder.isRecording) {
                                  await stop();
                                } else {
                                  await record();
                                }
                                AuthUserModel userModel =
                                    context.read<AuthProvider>().authUserModel!;

                                _chatProvider.sendAudio(
                                  userModel.id,
                                  userModel.userRegNo,
                                  userModel.userPhoneNumber,
                                  userModel.userName,
                                  value.selectedUser!.userId,
                                  value.selectedUser!.userRegNo,
                                  value.selectedUser!.userPhoneNo,
                                  value.selectedUser!.userName,
                                  audio,
                                );

                                setState(() {});
                              },
                              icon: Icon(recorder.isRecording
                                  ? Icons.stop
                                  : Icons.mic),
                            ),
                          if (!haveText)
                            IconButton(
                                onPressed: () async {},
                                icon: const Icon(Icons.camera_alt_outlined)),
                        ],
                      ),
                    ),
                    if (haveText)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(14.sp)),
                        onPressed: () {
                          AuthUserModel userModel =
                              context.read<AuthProvider>().authUserModel!;
                          value.sendMessage(
                              SendChatModel(
                                  userSenderId: userModel.id,
                                  userSenderName: userModel.userName,
                                  userSenderNumber: userModel.userPhoneNumber,
                                  userSenderRegNo: userModel.userRegNo,
                                  userReceiverId: value.selectedUser!.userId,
                                  userReceiverName:
                                      value.selectedUser!.userName,
                                  userReceiverRegNo:
                                      value.selectedUser!.userRegNo,
                                  userReceiverNumber:
                                      value.selectedUser!.userPhoneNo,
                                  textMasseg: _messageController.text),
                              context);

                          _messageController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.send),
                      )
                  ],
                )
              ],
            );
          }),
        ),
      ),
    ]);
  }
}
