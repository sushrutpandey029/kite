import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../provider/chat_provider.dart';
import 'chat_screen.dart';

class ChatListingPage extends StatefulWidget {
  const ChatListingPage({Key? key}) : super(key: key);

  @override
  State<ChatListingPage> createState() => _ChatListingPageState();
}

class _ChatListingPageState extends State<ChatListingPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ChatProvider>().fetchChatUsers(context);
      },
      child: Consumer<ChatProvider>(builder: (context, value, widget) {
        return ListView.builder(
          itemCount: value.chatUsersList.length,
          itemBuilder: (context, index) {
            return Container(
              height: 80,
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),

              // shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              // elevation: 4,
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    value.selectUser(index, context);
                  },
                  contentPadding: EdgeInsets.only(left: 2.w),
                  tileColor: const Color.fromARGB(255, 231, 231, 231),
                  leading: CircleAvatar(
                    radius: 20.sp,
                    child: const Icon(Icons.person),
                  ),
                  title: Text(value.chatUsersList.elementAt(index).userName),
                  subtitle: Row(
                    children: [
                      Text(
                        value.chatUsersList.elementAt(index).lastMessage,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          DateFormat.jm().format(value.chatUsersList
                              .elementAt(index)
                              .lastMessageTime),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 2.75.h,
                          child: value.chatUsersList
                                      .elementAt(index)
                                      .unreadMessagesCount ==
                                  0
                              ? null
                              : CircleAvatar(
                                  child: Text(
                                      value.chatUsersList
                                          .elementAt(index)
                                          .unreadMessagesCount
                                          .toString(),
                                      style: TextStyle(fontSize: 14.sp)),
                                ),
                        )
                      ],
                    ),
                  )),
            );
          },
        );
      }),
    );
  }
}
