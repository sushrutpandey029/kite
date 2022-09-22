import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/call/ui/screens/call_page.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:kite/chat/ui/screens/chat_profile_screen.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';

AppBar chatAppBar(BuildContext context) {
  return AppBar(
    title: Consumer<ChatProvider>(builder: (context, value, widget) {
      return InkWell(
        onTap: () {
          customNavigator(context, const ChatProfileScreen());
        },
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            SizedBox(
              width: 4.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25.w,
                  child: Text(
                    value.selectedUser!.userName,
                    style: whiteText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Online..',
                  style: TextStyle(fontSize: 15.sp),
                ),
              ],
            ),
          ],
        ),
      );
    }),
    actions: [
      Consumer<ChatProvider>(builder: (context, value, widget) {
        return IconButton(
            onPressed: () {
              customNavigator(
                  context,
                  CallPage(
                    calleeNumber: value.selectedUser!.userPhoneNo,
                    hasVideo: true,
                  ));
            },
            icon: const Icon(Icons.video_call));
      }),
      Consumer<ChatProvider>(builder: (context, value, widget) {
        return IconButton(
            onPressed: () {
              customNavigator(
                  context,
                  CallPage(
                    calleeNumber: value.selectedUser!.userPhoneNo,
                    hasVideo: false,
                  ));
            },
            icon: const Icon(Icons.phone));
      }),
      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(gradient: gradient1),
    ),
  );
}
