import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:provider/provider.dart';

import '../../../chat/provider/chat_provider.dart';
import '../../../chat/ui/screens/chat_screen.dart';
import '../../../chat/ui/screens/create_new_group_screen.dart';
import '../../../settings/ui/screens/contact_us_screen.dart';
import '../../../settings/ui/screens/qr_code_screen.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../util/custom_navigation.dart';
import 'add_new_contact_screen.dart';
import 'contacts.dart';

class ContactListPage extends StatefulWidget {
  ContactListPage(
      {Key? key, required this.phoneContacts, required this.matchedContacts})
      : super(key: key);

  List<AuthUserModel> matchedContacts = [];
  List<Contact> phoneContacts = [];

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  void initState() {
    // TODO: implement initState
    // context.read<ContactProvider>().getPhoneContacts();
    // context.read<ContactProvider>().matchContacts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final matchContact = widget.matchedContacts;
    final phoneContact = widget.phoneContacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.qr_code_2,
              color: Colors.white,
            ),
            onPressed: () {
              customNavigator(
                context,
                const QrCodePage(),
              ); // do something
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, value, widget) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateNewGroupScreen()),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 44.0),
                            child: Text("New group"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewContactScreen()),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person_add_alt,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 44.0),
                            child: Text("New contact"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: matchContact.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 0,
                    child: Card(
                      child: GestureDetector(
                        onTap: () {
                          // value.selectUser(index, context);
                          context.read<ChatProvider>().fetchChat(context);
                          customNavigator(
                            context,
                            ChatScreen(
                              isGroupChat: false,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(matchContact[index].userImage),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text(
                                  style: const TextStyle(color: Colors.black),
                                  matchContact[index].userName,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.phone),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.video_call,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneContacts(
                          phoneContacts: phoneContact,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 44.0),
                            child: Text("Invite"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactUsScreen(),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.help,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 44.0),
                            child: Text("Contact us"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
