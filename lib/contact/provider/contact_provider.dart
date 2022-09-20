import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/contact/repository/contact_repo.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactProvider extends ChangeNotifier {
  final ContactRepo _contactRepo = ContactRepo();

  List<Contact> phoneContact = [];
  List<AuthUserModel> regContacts = [];
  List<AuthUserModel> finalContacts = [];

  Future<List<Contact>?> getPhoneContacts() async {
    await _askPermissions();
    phoneContact = await ContactsService.getContacts(withThumbnails: false);
    // print(phoneContact);
    for (var element in phoneContact) {
      if (element.phones!.isNotEmpty) {
        // print(element.phones!.first.value!.replaceAll(' ', ''));
        return phoneContact;
      } else {
        return [];
      }
    }
  }

  Future<void> getRegContacts() async {
    regContacts = await _contactRepo.getContacts();
    // print(regContacts);
    for (var element in regContacts) {
      // print("Contact from database");
      // print(element.userPhoneNumber);
    }
  }

  Future<List<AuthUserModel>> matchContacts() async {
    await getPhoneContacts();
    await getRegContacts();
    for (var contact in phoneContact) {
      finalContacts.addAll(
        regContacts.where(
          (element) {
            if (contact.phones!.isNotEmpty) {
              return contact.phones!.first.value!.replaceAll(' ', '') ==
                  element.userPhoneNumber;
            } else {
              return false;
            }
          },
        ),
      );
    }
    print(finalContacts.length);
    return finalContacts;
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
      // final snackBar = SnackBar(content: Text('Access to contact data denied'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      // final snackBar =
      // SnackBar(content: Text('Contact data not available on device'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
