import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/authentication/ui/screens/get_mobile_no_screen.dart';
import 'package:kite/settings/repo/settings_repo.dart';
import 'package:kite/shared/ui/widgets/custom_dialouge.dart';
import 'package:provider/provider.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepo _settingsRepo = SettingsRepo();
  bool isLoading = false;

  Future<void> deleteAccount(
      BuildContext context, String reason, AuthUserModel userModel) async {
    isLoading = true;
    notifyListeners();

    try {
      await _settingsRepo.deleteAccount(userModel.id);
      if (reason != null) {
        await _settingsRepo.deleteReason(userModel);
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GetMobileNoPage()));
    } on DioError catch (e) {
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(
                message: e.message,
              ));
    }
  }
}
