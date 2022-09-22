import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/app.dart';
import 'package:kite/database/hive_models/auth_hive_model.dart';
import 'package:uuid/uuid.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'database/hive_models/message_hive_model.dart';

Future<void> backgroundMessageHandler(RemoteMessage event) async {
  Map message = event.toMap();
  log('BackgroudMesage=>${message.toString()}');
  var payload = message['data'];
  var roomId = payload['roomId'] as String;
  var callerName = payload['callerName'] as String;
  var uuid = payload['uuid'] as String;
  var hasVideo = payload['hasVideo'];

  final callUuid = uuid;

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        criticalAlert: true,
        autoDismissible: false,
        id: 10,
        channelKey: 'basic_channel',
        title: '$callerName is calling',
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'decline',
            label: 'Reject',
            isDangerousOption: true,
            enabled: true,
            buttonType: ActionButtonType.Default),
        NotificationActionButton(
            key: 'accept-$roomId',
            label: 'Accept',
            isDangerousOption: true,
            enabled: true,
            buttonType: ActionButtonType.Default),
      ]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(
    MessageHiveModelAdapter(),
  );
  Hive.registerAdapter(
    AuthHiveModelAdapter(),
  );
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'basic_channel_group',
        channelDescription: 'Calling',
        ledColor: Colors.white)
  ]);
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  await Hive.openBox<MessageHiveModel>('Messages');
  await Hive.openBox<AuthHiveModel>('Auth');
  await Firebase.initializeApp();

  runApp(const KiteApp());
}
