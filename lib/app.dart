import 'package:flutter/material.dart';

import 'package:kite/authentication/ui/screens/get_started_screen.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:kite/contact/provider/contact_provider.dart';
import 'package:kite/profile/provider/update_profile_provider.dart';
import 'package:kite/settings/providers/del_acc_provider.dart';
import 'package:kite/settings/ui/screens/setting_screen.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'authentication/provider/auth_provider.dart';
import 'chat/ui/screens/chat_screen.dart';

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
          ChangeNotifierProvider(create: (context) => DellAccProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: ThemeData.dark(),
          home: GetStartedPage(),
        ),
      );
    });
  }
}
