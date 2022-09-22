import 'package:flutter/material.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/settings/ui/screens/data_and_storage_screen.dart';
import 'package:kite/settings/ui/screens/help_screen.dart';
import 'package:kite/settings/ui/screens/notification_and_sound_screen.dart';
import 'package:kite/settings/ui/screens/privacy_and_security_screen.dart';
import 'package:kite/shared/constants/textstyle.dart';
import 'package:kite/shared/constants/url_constants.dart';
import 'package:kite/shared/ui/widgets/custom_app_bar.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/color_gradient.dart';
import 'qr_code_screen.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List titles = <String>[
    'Notification & Sounds',
    'Privacy and Security',
    'Data & Storage',
    'Language',
    'Help'
  ];
  List icons = <IconData>[
    Icons.notifications,
    Icons.lock,
    Icons.cloud,
    Icons.language,
    Icons.help,
  ];

  List subtitles = <String>[
    'Message, groups and calls',
    'End-to-end encryption and PINs',
    'Network & data usage and space',
  ];

  List onTapDestination = <Widget>[
    const NotificationSoundsPage(),
    const PrivacySecurityPage(),
    const DataStoragePage(),
    const Text('language'),
    const HelpPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Consumer<AuthProvider>(builder: (context, value, widget) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 22.sp,
                      foregroundImage: NetworkImage(
                          '$imgUrl/${value.authUserModel!.userImage}'),
                      child: const Icon(Icons.person),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        value.authUserModel!.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          customNavigator(context, const QrCodePage());
                        },
                        icon: Icon(
                          Icons.qr_code,
                          size: 28.sp,
                        ))
                  ],
                );
              }),
            ),
            const Divider(thickness: 3, color: Colors.black),
            for (int i = 0; i < 5; i++)
              ListTile(
                onTap: () {
                  if (i == 3) {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.sp))),
                        builder: (context) => SizedBox(
                              height: 40.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Languages',
                                      style: blueText1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'English',
                                      style: text1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Hindi',
                                      style: text1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'French',
                                      style: text1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Spanish',
                                      style: text1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Arabic',
                                      style: text1,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                    return;
                  }
                  customNavigator(context, onTapDestination.elementAt(i));
                },
                leading: Icon(
                  icons.elementAt(i),
                  color: Colors.blueAccent,
                ),
                title: Text(
                  titles.elementAt(i),
                  style: boldText1,
                ),
                subtitle: i < 3 ? Text(subtitles.elementAt(i)) : null,
              )
          ],
        ),
      ),
    );
  }
}
