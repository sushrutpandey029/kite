import 'package:flutter/material.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:kite/chat/ui/screens/chat_screen.dart';
import 'package:kite/contact/provider/contact_provider.dart';
import 'package:kite/contact/ui/screens/non_reg_contacts.dart';
import 'package:kite/shared/constants/textstyle.dart';
import 'package:kite/shared/constants/url_constants.dart';
import 'package:kite/shared/ui/widgets/custom_app_bar.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:azlistview/azlistview.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Contacts', actionIcons: [Icons.search]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                // boxShadow: const [
                //   BoxShadow(
                //       offset: Offset(2, 5), color: Colors.grey, blurRadius: 20)
                // ]
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.group_add,
                          size: 24.sp,
                          color: const Color.fromARGB(255, 55, 78, 191),
                        ),
                        SizedBox(
                          width: 2.h,
                        ),
                        Text(
                          'New group call',
                          style: text1,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h, left: 4.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          size: 24.sp,
                          color: const Color.fromARGB(255, 55, 78, 191),
                        ),
                        SizedBox(
                          width: 2.h,
                        ),
                        Text(
                          'New contact',
                          style: text1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h, left: 4.w),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              customNavigator(context, NonRegContacts()),
                          icon: Icon(
                            Icons.add_comment_outlined,
                            size: 24.sp,
                            color: const Color.fromARGB(255, 55, 78, 191),
                          ),
                        ),
                        SizedBox(
                          width: 2.h,
                        ),
                        Text(
                          'Invite',
                          style: text1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100.w,
                    color: Colors.grey.shade300,
                    padding: EdgeInsets.only(left: 2.w, top: 2.w, bottom: 2.w),
                    child: Text(
                      'People on kite',
                      style: text2,
                    ),
                  )
                ],
              ),
            ),
            Consumer<ContactProvider>(builder: (context, value, widget) {
              value.finalContacts.sort(
                (a, b) => a.userName.compareTo(b.userName),
              );
              return Column(
                children: [
                  // AzListView(data: ['wd','asdas'], itemCount: value.finalContacts.length, itemBuilder: ((context, index) {
                  //       AuthUserModel userModel =
                  //           value.finalContacts.elementAt(index);
                  //       return Padding(
                  //         padding: EdgeInsets.only(top: 0.5.h),
                  //         child: ListTile(
                  //           // shape: const UnderlineInputBorder(
                  //           //     borderSide: BorderSide(color: Colors.grey)),
                  //           leading: CircleAvatar(
                  //             child:
                  //                 // userModel.userImage != null
                  //                 //     ? Image.asset(userModel.userImage)
                  //                 // :
                  //                 Icon(Icons.person),
                  //           ),
                  //           title: Text(userModel.userName),
                  //           trailing: SizedBox(
                  //             width: 35.w,
                  //             child: Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Material(
                  //                   shape: const CircleBorder(),
                  //                   elevation: 10,
                  //                   child: CircleAvatar(
                  //                     child: IconButton(
                  //                         onPressed: () {},
                  //                         icon: const Icon(Icons.edit)),
                  //                   ),
                  //                 ),
                  //                 Material(
                  //                   shape: const CircleBorder(),
                  //                   elevation: 10,
                  //                   child: CircleAvatar(
                  //                     child: IconButton(
                  //                         onPressed: () {},
                  //                         icon: const Icon(Icons.call)),
                  //                   ),
                  //                 ),
                  //                 Material(
                  //                   shape: const CircleBorder(),
                  //                   elevation: 10,
                  //                   child: CircleAvatar(
                  //                     child: IconButton(
                  //                         onPressed: () {},
                  //                         icon: const Icon(Icons.video_call)),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     })),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.finalContacts.length,
                      itemBuilder: ((context, index) {
                        AuthUserModel userModel =
                            value.finalContacts.elementAt(index);
                        return Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: ListTile(
                            onTap: () {
                              context
                                  .read<ChatProvider>()
                                  .selectUser(index, context, true, userModel);
                              customNavigator(
                                  context, ChatScreen(isGroupChat: false));
                            },
                            // shape: const UnderlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.grey)),
                            leading: userModel.userImage != null
                                ? CircleAvatar(
                                    child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      '$imgUrl/${userModel.userImage}',
                                      fit: BoxFit.contain,
                                    ),
                                  ))
                                : CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                            title: Text(userModel.userName),
                            trailing: SizedBox(
                              width: 35.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    shape: const CircleBorder(),
                                    elevation: 10,
                                    child: CircleAvatar(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.edit)),
                                    ),
                                  ),
                                  Material(
                                    shape: const CircleBorder(),
                                    elevation: 10,
                                    child: CircleAvatar(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.call)),
                                    ),
                                  ),
                                  Material(
                                    shape: const CircleBorder(),
                                    elevation: 10,
                                    child: CircleAvatar(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.video_call)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
