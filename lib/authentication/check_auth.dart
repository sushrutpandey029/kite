import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/authentication/ui/screens/get_started_screen.dart';

import '../shared/ui/screens/wrapper.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  // final storage = const FlutterSecureStorage();
  String? value;

  readStoerage() async {
    // value = await storage.read(key: 'numKey');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readStoerage();
  }

  final AuthProvider authProvider = AuthProvider();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (value != null) {
              authProvider.getUser(value!);
              return const Wrapper();
            } else {
              return const GetStartedPage();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
