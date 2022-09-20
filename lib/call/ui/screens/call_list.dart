import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:kite/shared/constants/textstyle.dart';
import 'package:kite/shared/ui/widgets/custom_app_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../chat/ui/screens/create_new_group_screen.dart';
import '../../../contact/ui/screens/add_new_contact_screen.dart';
import '../../../contact/ui/screens/contact_list.dart';
import '../../../contact/ui/screens/widget/search_widget.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../util/custom_navigation.dart';

class CallListPage extends StatefulWidget {
  CallListPage(
      {Key? key, required this.phoneContacts, required this.matchedContacts})
      : super(key: key);

  List<AuthUserModel> matchedContacts = [];
  List<Contact> phoneContacts = [];

  @override
  State<CallListPage> createState() => _CallListPageState();
}

class _CallListPageState extends State<CallListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calls"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              })
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(2, 5), color: Colors.grey, blurRadius: 20)
                ]),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateNewGroupScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.group_add,
                          size: 24.sp,
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 1.h, left: 4.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewContactScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          size: 24.sp,
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
                ),
                const Divider(
                  thickness: 3,
                  color: Colors.black,
                  height: 0,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 50,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: .5.h),
                      child: ListTile(
                        shape: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text('contact $index'),
                        trailing: SizedBox(
                          width: 35.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      shape: const CircleBorder()),
                                  onPressed: () {},
                                  child: const Icon(Icons.call)),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      shape: const CircleBorder()),
                                  onPressed: () {},
                                  child: const Icon(Icons.video_call)),
                            ],
                          ),
                        ),
                      ),
                    );
                  })))
        ],
      ),
    );
  }
}
