import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/authentication/check_auth.dart';
import 'package:kite/authentication/ui/screens/get_started_screen.dart';
import 'package:kite/call/ui/screens/call_page.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:kite/contact/provider/contact_provider.dart';
import 'package:kite/database/hive_models/auth_hive_model.dart';
import 'package:kite/database/hive_models/boxes.dart';
import 'package:kite/main.dart';

import 'package:kite/profile/provider/update_profile_provider.dart';
import 'package:kite/shared/ui/screens/wrapper.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'authentication/provider/auth_provider.dart';

class KiteApp extends StatefulWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  State<KiteApp> createState() => _KiteAppState();
}

class _KiteAppState extends State<KiteApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => UpdateProfileProvider()),
          ChangeNotifierProvider(create: (context) => ChatProvider()),
          ChangeNotifierProvider(create: (context) => ContactProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: ThemeData.dark(),
          home: WidgetTest(),
          //
        ),
      );
    });
  }
}

class WidgetTest extends StatefulWidget {
  WidgetTest({Key? key}) : super(key: key);

  @override
  State<WidgetTest> createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  final myBox = Boxes.getAuthHive();
  AuthHiveModel? authPh = AuthHiveModel()..pNumber = '';
  StreamSubscription<ReceivedAction>? _actionStreamSubscription;

  void listen(
      BuildContext context, String hasVideo, String calleeNumber) async {
    await _actionStreamSubscription?.cancel();
    _actionStreamSubscription =
        AwesomeNotifications().actionStream.listen((message) {
      if (message.buttonKeyPressed.startsWith("accept")) {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => CallPage(
                  calleeNumber: calleeNumber,
                  callStatus: CallStatus.calling,
                  roomId: message.buttonKeyPressed.replaceAll("accept-", ""),
                  hasVideo: hasVideo == 'true' ? true : false,
                )));
      } else if (message.buttonKeyPressed == "decline") {
        // decline call
      }
    });
  }

  @override
  void dispose() {
    _actionStreamSubscription!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    authPh = myBox.get('authPh');
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // listen();
    FirebaseMessaging.instance.getToken().then((token) {
      print('[FCM] token =>  $token!');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map msg = message.toMap();
      log('BackgroudMesage=>${message.toString()}');
      var payload = msg['data'];
      // var roomId = payload['roomId'] as String;
      var callerNumber = payload['callerNumber'] as String;
      // var uuid = payload['uuid'] as String;
      var hasVideo = payload['hasVideo'];
      listen(context, hasVideo, callerNumber);
      backgroundMessageHandler(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return authPh == null ? const GetStartedPage() : const Wrapper();
  }
}
