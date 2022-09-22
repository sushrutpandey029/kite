import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:kite/shared/constants/textstyle.dart';
import 'package:kite/shared/ui/widgets/custom_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddNewContactScreen extends StatefulWidget {
  const AddNewContactScreen({Key? key}) : super(key: key);

  @override
  State<AddNewContactScreen> createState() => _AddNewContactScreenState();
}

class _AddNewContactScreenState extends State<AddNewContactScreen> {
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> saveContactInPhone() async {
    try {
      print("saving Conatct");
      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;

        if (permission == PermissionStatus.granted) {
          Contact newContact = new Contact();
          newContact.givenName = NameController.text;
          // newContact.emails = [
          //   Item(label: "email", value: myController3.text)
          // ];
          // newContact.company = myController2.text;
          newContact.phones = [
            Item(label: "mobile", value: numberController.text)
          ];
          // newContact.postalAddresses = [
          //   PostalAddress(region: myController6.text)
          // ];
          await ContactsService.addContact(newContact);
        } else {
          //_handleInvalidPermissions(context);
        }
      } else {
        Contact newContact = new Contact();
        newContact.givenName = NameController.text;

        newContact.phones = [
          Item(label: "mobile", value: numberController.text)
        ];

        await ContactsService.addContact(newContact);
      }
      print("object");
    } catch (e) {
      print(e);
    }
  }

  TextEditingController NameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  // addContact(String fName, String lName, String phone) {}
  //
  // saveContact(Contact _contact) async {
  //   await ContactsService.addContact(_contact);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Add New Contact'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2.h,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: ' First Name',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
                controller: NameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2.h,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Mobile number',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
                controller: numberController,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              child: Text(
                'Submit',
                style: whiteText1,
              ),
              onPressed: () {
                saveContactInPhone();
              },
            )
          ],
        ),
      ),
    );
  }
}
