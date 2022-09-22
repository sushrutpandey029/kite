import 'package:flutter/material.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/chat/ui/screens/create_new_group_screen.dart';
import 'package:kite/contact/ui/screens/add_new_contact_screen.dart';
import 'package:kite/profile/ui/screens/profile_screen.dart';
import 'package:kite/settings/ui/screens/help_screen.dart';
import 'package:kite/settings/ui/screens/setting_screen.dart';
import 'package:kite/shared/constants/textstyle.dart';
import 'package:kite/shared/constants/url_constants.dart';
import 'package:kite/wallet/ui/screens/activate_wallet_screen.dart';
import 'package:kite/web_search/ui/screen/web_search_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../contact/ui/screens/contact_list.dart';
import '../../../util/custom_navigation.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List drawerItemTitle = <String>[
      'New Groups',
      'Contacts',
      'Wallet',
      'Themes & modes',
      'Web search',
      'Settings',
      'Invite your friends',
      'Help'
    ];
    List drawerItemIcon = <IconData>[
      Icons.group,
      Icons.contacts,
      Icons.wallet,
      Icons.amp_stories,
      Icons.language,
      Icons.settings,
      Icons.mail,
      Icons.help
    ];
    List tapDestination = <Widget?>[
      const CreateNewGroupScreen(),
      ContactListPage(),
      const ActivateWalletScreen(),
      null,
      const WebSearchPage(),
      const SettingPage(),
      null,
      const HelpPage()
    ];
    return Drawer(
      width: 65.w,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(20.sp))),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).closeEndDrawer();
              customNavigator(context, const ProfilePage());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(20.sp)),
                color: const Color.fromARGB(255, 98, 200, 255),
              ),
              height: 15.h,
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child:
                    Consumer<AuthProvider>(builder: (context, value, widget) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(
                            '$imgUrl/${value.authUserModel!.userImage}'),
                        child: const Icon(Icons.person),
                      ),
                      Text(
                        value.authUserModel!.userName,
                        style: whiteText1,
                      ),
                      Text(
                        value.authUserModel!.userPhoneNumber,
                        style: whiteText1,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              customNavigator(context, const AddNewContactScreen());
            },
            leading: const Material(
                elevation: 5,
                shape: CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  ),
                )),
            title: const Text('+ Add new account'),
          ),
          const Divider(
            thickness: 2.5,
          ),
          for (int i = 0; i < 4; i++)
            ListTile(
              onTap: tapDestination.elementAt(i) != null
                  ? () {
                      customNavigator(context, tapDestination.elementAt(i));
                    }
                  : null,
              leading: Icon(
                drawerItemIcon.elementAt(i),
                color: Colors.blueAccent,
              ),
              title: Text(drawerItemTitle.elementAt(i)),
            ),
          const Divider(
            thickness: 2.5,
          ),
          for (int i = 4; i < 8; i++)
            ListTile(
              onTap: tapDestination.elementAt(i) != null
                  ? () {
                      customNavigator(context, tapDestination.elementAt(i));
                    }
                  : null,
              leading: Icon(
                drawerItemIcon.elementAt(i),
                color: Colors.blueAccent,
              ),
              title: Text(drawerItemTitle.elementAt(i)),
            )
        ],
      ),
    );
  }
}
