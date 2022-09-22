import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/settings/repository/del_repo.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../authentication/ui/screens/get_started_screen.dart';
import '../../shared/ui/widgets/custom_dialouge.dart';

class DellAccProvider extends ChangeNotifier {
  final DellAccountRepo _dellAccountRepo = DellAccountRepo();

  Future<void> dellAccount(
    BuildContext context, {
    required String userId,
  }) async {
    try {
      notifyListeners();
      _dellAccountRepo.delAccount(userId);
      notifyListeners();
      Navigator.pop(context);
    } on DioError catch (e) {
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(
                message: e.message,
              ));
    }
  }

  Future<void> dellAccountReason(
    BuildContext context, {
    required String userId,
    required String userRegNo,
    required String userName,
    required String userNumber,
    required String delReasons,
  }) async {
    try {
      notifyListeners();

      if (userName != null ||
          userRegNo != null ||
          delReasons != null ||
          userNumber != null) {
        dellAccount(context, userId: userId);

        _dellAccountRepo.delAccountReasons(
            userRegNo, userName, userNumber, delReasons);

        Fluttertoast.showToast(
            msg: "Account deleted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GetStartedPage()),
        );
      }

      notifyListeners();
    } on DioError catch (e) {
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(
                message: e.message,
              ));
    }
  }
}
