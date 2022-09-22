import 'package:flutter/material.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:kite/chat/ui/screens/chat_listing_screen.dart';
import 'package:kite/contact/provider/contact_provider.dart';
import 'package:kite/contact/ui/screens/contact_list.dart';
import 'package:kite/database/hive_models/auth_hive_model.dart';
import 'package:kite/database/hive_models/boxes.dart';
import 'package:kite/settings/ui/screens/setting_screen.dart';
import 'package:kite/shared/ui/widgets/app_drawer.dart';
import 'package:kite/shared/ui/widgets/custom_app_bar.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../call/ui/screens/call_list.dart';
import '../../../web_search/ui/screen/web_search_screen.dart';
import '../../constants/color_gradient.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final myBox = Boxes.getAuthHive();
  AuthHiveModel? authPh = AuthHiveModel()..pNumber = '';

  @override
  void initState() {
    context.read<ContactProvider>().matchContacts(context);
    authPh = myBox.get('authPh');
    context
        .read<AuthProvider>()
        .getUser(authPh!.pNumber)
        .then((value) => context.read<ChatProvider>().fetchChatUsers(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SizedBox(height: 85.h, child: const AppDrawer()),
      appBar: customAppBar(
        'KITE',
        isHome: true,
        actionIcons: [Icons.search],
      ),
      body: context.watch<ChatProvider>().isLoading
          ? const Center(child: CircularProgressIndicator())
          : const ChatListingPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Material(
          elevation: 10,
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {
                customNavigator(context, const ContactListPage());
              },
              child: Icon(
                Icons.add,
                size: 30.sp,
              ),
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 7.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(6.h)),
              gradient: gradient1,
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(204, 60, 60, 60),
                    offset: Offset(0, -1.h),
                    blurRadius: 20)
              ]),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                iconSize: 28.sp,
                onPressed: () {
                  customNavigator(context, const WebSearchPage());
                },
                icon: Image.asset(
                  'assets/images/web-search.png',
                  fit: BoxFit.cover,
                )),
            IconButton(
                iconSize: 24.sp,
                onPressed: () {
                  customNavigator(context, const CallListPage());
                },
                icon: const Icon(Icons.call)),
            SizedBox(
              width: 10.w,
            ),
            IconButton(
                iconSize: 26.sp,
                onPressed: () {},
                icon: Image.asset(
                  'assets/images/message.png',
                  fit: BoxFit.cover,
                )),
            IconButton(
                iconSize: 24.sp,
                onPressed: () {
                  customNavigator(context, const SettingPage());
                },
                icon: const Icon(Icons.settings)),
          ]),
        ),
      ),
    );
  }
}
