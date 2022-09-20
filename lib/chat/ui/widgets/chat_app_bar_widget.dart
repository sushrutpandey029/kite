import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:kite/chat/ui/screens/chat_profile_screen.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';

enum MenuItem {
  item1,
  item2,
  item3,
  item4,
  item5,
  item6,
  item7,
}

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
                Text(
                  value.selectedUser!.userName,
                  style: whiteText1,
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
      IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
      PopupMenuButton<MenuItem>(
          onSelected: (value) {
            if (value == MenuItem.item1) {}
            if (value == MenuItem.item2) {}
            if (value == MenuItem.item3) {}
            if (value == MenuItem.item4) {}
            if (value == MenuItem.item5) {}
            if (value == MenuItem.item6) {}
            if (value == MenuItem.item7) {}
          },
          itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text('View contact'),
                ),
                const PopupMenuItem(
                  child: Text('Media, links and docs'),
                ),
                const PopupMenuItem(
                  child: Text('Search'),
                ),
                const PopupMenuItem(
                  child: Text('mute notification'),
                ),
                const PopupMenuItem(
                  child: Text('Disappearing messages'),
                ),
                const PopupMenuItem(
                  value: MenuItem.item6,
                  child: Text('Wallpaper'),
                ),
                const PopupMenuItem(
                  child: Text('More'),
                ),
              ])
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(gradient: gradient1),
    ),
  );
}

// icon: const Icon(
// Icons.more_vert,
// color: Colors.white,
// ),
