import 'dart:developer';
import 'dart:ui';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/call/ui/screens/model/asd.dart';
import 'package:kite/shared/constants/url_constants.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum CallStatus { calling, accepted, ringing }

class CallPage extends StatefulWidget {
  final String calleeNumber;
  final CallStatus? callStatus;
  final String? roomId;
  final bool hasVideo;
  const CallPage(
      {Key? key,
      required this.calleeNumber,
      this.callStatus,
      this.roomId,
      required this.hasVideo})
      : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late CallStatus callStatus;
  Signaling signaling = Signaling();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? roomId;
  bool hasVideo = false;
  late AuthUserModel userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    hasVideo = widget.hasVideo;
    callStatus = widget.callStatus ?? CallStatus.calling;
    if (callStatus == CallStatus.calling) {
      context.read<AuthProvider>().getUserForCall(widget.calleeNumber).then(
          (value) =>
              userModel = context.read<AuthProvider>().authUserModelForCall!);
    }

    setState(() {});
    initialiseSignals();
  }

  initialiseSignals() async {
    localRenderer.initialize();
    remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    });
    if (hasVideo) {
      signaling
          .openUserMedia(localRenderer, remoteRenderer)
          .then((value) => setState(
                () {},
              ));
    }
    if (callStatus == CallStatus.calling) {
      String callerName = context.read<AuthProvider>().authUserModel!.userName;
      String callerNumber =
          context.read<AuthProvider>().authUserModel!.userPhoneNumber;
      roomId = await signaling.createRoom(remoteRenderer);

      try {
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('sendCallNotification');
        final response = await callable.call(<String, dynamic>{
          'roomId': roomId,
          'callerName': callerName,
          'callerNumber': callerNumber,
          'uuid': userModel.userUid,
          'hasVideo': hasVideo == true ? 'true' : 'false',
          'fcm': userModel.userFcm
        });
        log(response.toString());
      } catch (err) {
        log(err.toString());
      }
    } else {
      roomId = widget.roomId;
      signaling.joinRoom(roomId!, remoteRenderer);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    signaling.hangUp(localRenderer);
    super.dispose();
  }

  Widget getBody() {
    switch (callStatus) {
      case CallStatus.accepted:
        return Consumer<AuthProvider>(builder: (context, value, widget) {
          return Center(
            child: Stack(
              children: [
                hasVideo
                    ? Container(
                        decoration: const BoxDecoration(color: Colors.black),
                        width: 100.w,
                        height: 100.h,
                        child: RTCVideoView(
                          localRenderer,
                          mirror: true,
                          // filterQuality: FilterQuality.high,
                        ))
                    : const SizedBox(),
                Container(
                  // color: Colors.black87,
                  width: 100.w,
                  height: 100.h,
                ),
                Positioned(
                  left: 30.w,
                  top: 30.h,
                  child: Column(
                    children: [
                      // Container(
                      //   width: 150,
                      //   height: 150,
                      //   decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //           image: NetworkImage(
                      //               '$imgUrl/${value.authUserModelForCall!.userImage}'),
                      //           fit: BoxFit.cover)),
                      // ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        value.authUserModelForCall!.userName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Calling...",
                        style: TextStyle(
                            color: Colors.white,
                            shadows: [
                              BoxShadow(color: Colors.black, blurRadius: 3)
                            ],
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      case CallStatus.calling:
        return Consumer<AuthProvider>(builder: (context, value, widget) {
          return Center(
            child: Stack(
              children: [
                hasVideo
                    ? Container(
                        decoration: const BoxDecoration(color: Colors.black),
                        width: 100.w,
                        height: 100.h,
                        child: RTCVideoView(remoteRenderer))
                    : const SizedBox(),
                hasVideo
                    ? Positioned(
                        bottom: 60,
                        right: 0,
                        child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.black),
                            width: 30.w,
                            height: 20.h,
                            child: RTCVideoView(localRenderer, mirror: true)),
                      )
                    : const SizedBox(),
                hasVideo
                    ? const SizedBox()
                    : const SizedBox(
                        height: 100,
                      ),
                hasVideo
                    ? const SizedBox()
                    : Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '$imgUrl/${value.authUserModelForCall!.userImage}'),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            value.authUserModelForCall!.userName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Calling...",
                            style: TextStyle(
                                color: Colors.white,
                                shadows: [
                                  BoxShadow(color: Colors.black, blurRadius: 3)
                                ],
                                fontSize: 16),
                          )
                          // Countup(
                          //   begin: 0,
                          //   style: const TextStyle(
                          //       color: Colors.white,
                          //       shadows: [
                          //         BoxShadow(color: Colors.black, blurRadius: 3)
                          //       ],
                          //       fontSize: 16),
                          //   end: 100000,
                          // ),
                        ],
                      ),
              ],
            ),
          );
        });
      case CallStatus.ringing:
        return Consumer<AuthProvider>(builder: (context, value, widget) {
          return Column(
            children: [
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                '$imgUrl/${value.authUserModel!.userImage}'),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    value.authUserModel!.userName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Calling...",
                    style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          BoxShadow(color: Colors.black, blurRadius: 3)
                        ],
                        fontSize: 16),
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.phone, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Accept",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                        child: const Icon(Icons.call_end, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Decline",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Decline & Send Message",
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRect(
                child:
                    // BackdropFilter(
                    // filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    // child:
                    Container(
                  // width: SizeConfig.screenWidth * 0.75,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "I'll call you back",
                          style: TextStyle(color: Colors.white54),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Sorry, I can't talk right now",
                          style: TextStyle(color: Colors.white54),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ),
              const SizedBox(
                height: 80,
              ),
            ],
          );
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<AuthProvider>(builder: (context, value, widget) {
            return Container(
                // width: SizeConfig.screenWidth,
                // height: SizeConfig.screenHeight,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            '$imgUrl/${value.authUserModel!.userImage}'),
                        fit: BoxFit.cover)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(1)),
                  ),
                ));
          }),
          // ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : getBody(),
          SlidingUpPanel(
            panel: Container(
              color: Colors.black87,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: Icon(Icons.speaker), onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.soap_rounded), onPressed: () {}),
                    IconButton(icon: Icon(Icons.call_end), onPressed: () {}),
                  ]),
            ),
            minHeight: 90,
            maxHeight: 200,
            collapsed: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: const Icon(
                          Icons.speaker,
                          color: Colors.white,
                        ),
                        onPressed: () {}),
                    IconButton(
                        icon: const Icon(
                          Icons.mic_off_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {}),
                    IconButton(
                        icon: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          signaling.hangUp(localRenderer);
                          Navigator.pop(context);
                        }),
                  ]),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          )
        ],
      ),
    );
  }
}
