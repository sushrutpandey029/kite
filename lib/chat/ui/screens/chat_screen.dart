import 'dart:async';
import 'dart:io';

import 'package:audio_wave/audio_wave.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kite/chat/ui/widgets/chat_app_bar_widget.dart';
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
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.isGroupChat}) : super(key: key);
  bool isGroupChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final recorder = FlutterSoundRecorder();
  bool haveText = false;
  bool isAttaching = false;
  bool isRecording = false;
  bool isRecorderReady = false;
  final TextEditingController _messageController = TextEditingController();
  final ChatProvider _chatProvider = ChatProvider();
  final ImagePicker _picker = ImagePicker();

  // Signaling signaling = Signaling();
  // RTCVideoRenderer localRenderer = RTCVideoRenderer();
  // RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  // String? roomId;
  // TextEditingController textEditingController = TextEditingController();

  // final ScrollController _scrollController = ScrollController(initialScrollOffset: 100);

  String audio = '';

  Future record() async {
    if (!isRecorderReady) {
      return;
    }
    await recorder.startRecorder(toFile: 'audio');
  }

  Future<String> stop() async {
    // print(await recorder.stopRecorder());
    if (!isRecorderReady) {
      return '';
    }
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    audio = path;

    print('recorded audio:$path');
    return audio;
  }

  Future initRecorder() async {
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getMicrophonePermission();
    print(permissionStatus);
    if (permissionStatus == PermissionStatus.granted) {
      await recorder.openRecorder();
      isRecorderReady = true;
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

  void reloadMessage() {
    // Timer.periodic(Duration(seconds: 2), (timer) {
    //   if (mounted) {
    context.read<ChatProvider>().fetchChat(context);
    //   } else {
    //     timer.cancel();
    //     print('cancelled');
    //   }
    // });
  }

  @override
  void dispose() {
    _messageController.dispose();
    // localRenderer.dispose();
    // remoteRenderer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initRecorder();
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
    // reloadMessage();

    // localRenderer.initialize();
    // remoteRenderer.initialize();

    // signaling.onAddRemoteStream = ((stream) {
    //   remoteRenderer.srcObject = stream;
    // });

    super.initState();
  }

  String renderMessage(var chatMessage) {
    if (chatMessage.imageMessage != '') {
      return chatMessage.imageMessage;
    } else if (chatMessage.audioMessage != '') {
      return chatMessage.audioMessage;
    } else {
      return chatMessage.textMasseg;
    }
  }

  String findType(var chatMessage) {
    if (chatMessage.audioMessage != '') {
      return 'audio';
    } else if (chatMessage.imageMessage != '') {
      return 'image';
    } else {
      return 'text';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatAppBar(context),
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
                            type:
                                findType(value.finalChatList.elementAt(index)),
                            message: renderMessage(
                                value.finalChatList.elementAt(index)),
                            time: DateFormat.jm().format(
                                value.finalChatList.elementAt(index).datetime),
                            isByUser: value.finalChatList
                                    .elementAt(index)
                                    .senderId ==
                                context.read<AuthProvider>().authUserModel!.id,
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
              isAttaching
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 2.h, horizontal: 2.w + 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                // backgroundColor: Colors.white,

                                child: IconButton(
                                  onPressed: (() async {
                                    // Pick an image
                                    final XFile? pickedImage = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedImage != null) {
                                      // setState(() {
                                      //   image = File(pickedImage.path);
                                      // });
                                      AuthUserModel userModel = context
                                          .read<AuthProvider>()
                                          .authUserModel!;
                                      _chatProvider.sendImage(
                                          SendChatModel(
                                            userSenderId: userModel.id,
                                            userSenderName: userModel.userName,
                                            userSenderNumber:
                                                userModel.userPhoneNumber,
                                            userSenderRegNo:
                                                userModel.userRegNo,
                                            userReceiverId:
                                                value.selectedUser!.userId,
                                            userReceiverName:
                                                value.selectedUser!.userName,
                                            userReceiverRegNo:
                                                value.selectedUser!.userRegNo,
                                            userReceiverNumber:
                                                value.selectedUser!.userPhoneNo,
                                            textMasseg: _messageController.text,
                                            imageMessage: pickedImage.path,
                                            audioMessage: '',
                                          ),
                                          context);
                                    }
                                  }),
                                  icon: const Icon(Icons.image),
                                  iconSize: 20,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0.5.h),
                                child: const Text(
                                  "Gallery",
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                // backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: (() {
                                    print("Hello");
                                  }),
                                  icon: const Icon(Icons.person),
                                  iconSize: 20,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0.5.h),
                                child: const Text("Contacts"),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                // backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: (() async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(allowMultiple: true);
                                    if (result != null) {
                                      List<File> files = result.paths
                                          .map((path) => File(path!))
                                          .toList();
                                      print(files);
                                    } else {
                                      // User canceled the picker
                                    }
                                  }),
                                  icon: const Icon(Icons.description),
                                  iconSize: 20,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0.5.h),
                                child: const Text("Files"),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                // backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: (() {
                                    print("Hello");
                                  }),
                                  icon: const Icon(Icons.near_me),
                                  iconSize: 20,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0.5.h),
                                child: const Text("Location"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
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
                          child: recorder.isRecording
                              ? AudioWave(
                                  height: 32,
                                  width: 20,
                                  spacing: 2.5,
                                  alignment: 'right',
                                  animationLoop: 2,
                                  beatRate: Duration(milliseconds: 1000),
                                  bars: [
                                    AudioWaveBar(
                                        heightFactor: 0.9,
                                        color: Colors.lightBlueAccent),
                                    AudioWaveBar(
                                        heightFactor: 0.3, color: Colors.blue),
                                    AudioWaveBar(
                                        heightFactor: 0.5, color: Colors.black),
                                  ],
                                )
                              : TextField(
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
                            onPressed: () {
                              setState(() {
                                isAttaching = !isAttaching;
                              });
                            },
                            icon: const Icon(Icons.attach_file)),
                        if (!haveText)
                          IconButton(
                            onPressed: () async {
                              if (recorder.isRecording) {
                                String audioFile = await stop();
                                if (audioFile != "") {
                                  AuthUserModel userModel = context
                                      .read<AuthProvider>()
                                      .authUserModel!;
                                  value.sendAudio(
                                      SendChatModel(
                                        userSenderId: userModel.id,
                                        userSenderName: userModel.userName,
                                        userSenderNumber:
                                            userModel.userPhoneNumber,
                                        userSenderRegNo: userModel.userRegNo,
                                        userReceiverId:
                                            value.selectedUser!.userId,
                                        userReceiverName:
                                            value.selectedUser!.userName,
                                        userReceiverRegNo:
                                            value.selectedUser!.userRegNo,
                                        userReceiverNumber:
                                            value.selectedUser!.userPhoneNo,
                                        textMasseg: _messageController.text,
                                        imageMessage: '',
                                        audioMessage: audioFile,
                                      ),
                                      context);
                                }
                              } else {
                                await record();
                              }

                              print(audio);

                              setState(() {
                                // recorder.isRecording = false;
                              });
                            },
                            icon: Icon(
                                recorder.isRecording ? Icons.stop : Icons.mic),
                          ),
                        if (!haveText)
                          IconButton(
                              onPressed: () {},
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
                              userReceiverName: value.selectedUser!.userName,
                              userReceiverRegNo: value.selectedUser!.userRegNo,
                              userReceiverNumber:
                                  value.selectedUser!.userPhoneNo,
                              textMasseg: _messageController.text,
                              imageMessage: '',
                              audioMessage: '',
                            ),
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
    );
  }
}
