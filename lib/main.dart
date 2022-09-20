import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/app.dart';

import 'database/hive_models/message_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MessageHiveModelAdapter());
  await Hive.openBox<MessageHiveModel>('Messages');
  await Firebase.initializeApp();

  runApp(const KiteApp());
}
