import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/authentication/model/join_user_model.dart';
import 'package:kite/authentication/repository/auth_repo.dart';
import 'package:kite/authentication/ui/screens/get_otp_screen.dart';
import 'package:kite/authentication/ui/screens/set_profile_screen.dart';
import 'package:kite/shared/ui/widgets/custom_dialouge.dart';
import 'package:kite/util/custom_navigation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../shared/ui/screens/wrapper.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  String? _verificationId;
  bool isLoading = false;
  AuthUserModel? authUserModel;
  JoinUserModel joinUserModel = JoinUserModel(
    userRegNo: "user_reg_no",
    country: "country",
    userPhoneNumber: "user_phone_number",
    userImage: "user_image",
    userName: "user_name",
    userBio: "user_bio",
    userDob: DateTime.now(),
    userIpAddress: "user_ip_address",
    userPhoneName: "user_phone_name",
  );

  Future<void> sendOtp(String phoneNumber, BuildContext context) async {
    await _authRepo.sendOtp(phoneNumber, _verificationCompleted,
        _verificationFailed, _codeSent, _codeAutoRetrievalTimeOut);
    joinUserModel.userPhoneNumber = phoneNumber;
    customNavigator(context, const GetOtpPage());
  }

  void _verificationCompleted(PhoneAuthCredential phoneAuthCredential) {}

  void _verificationFailed(FirebaseAuthException exception) {}

  void _codeSent(String code, [int? i]) {
    _verificationId = code;
  }

  void _codeAutoRetrievalTimeOut(String code) {
    _verificationId = code;
  }

  Future<void> authenticate(String otp, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await _authRepo.authenticate(otp, _verificationId!);

      await getUser(joinUserModel.userPhoneNumber);
      if (authUserModel != null) {
        print(authUserModel);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Wrapper(),
          ),
        );
      } else {
        customNavigator(context, const SetProfilePage());
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(message: e.message ?? ''));
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> joinUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    joinUserModel.userIpAddress = await _getLocalIpAddress() ?? '';
    joinUserModel.userPhoneName = androidDeviceInfo.model ?? '';
    joinUserModel.userRegNo = _generateRegistrationNumber();
    //todo:something here

    try {
      bool isJoined = await _authRepo.joinUser(joinUserModel);
      if (isJoined) {
        getUser(joinUserModel.userPhoneNumber);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Wrapper(),
          ),
        );
      }
    } on DioError catch (e) {
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(message: e.message));
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getUser(String userMobileNumber) async {
    try {
      authUserModel = await _authRepo.getUser(userMobileNumber);
      print(authUserModel);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  static Future<String?> _getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return null;
        }
      }
    }
  }

  String _generateRegistrationNumber() {
    DateTime dateTime = DateTime.now();
    int timeFactor = dateTime.millisecondsSinceEpoch % 1000000;

    String regNo = 'KITE${timeFactor.toString()}${dateTime.year}';
    return regNo;
  }
}
