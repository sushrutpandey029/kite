import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/profile/repo/update_profile_repo.dart';
import 'package:kite/shared/ui/widgets/custom_dialouge.dart';
import 'package:provider/provider.dart';

import '../../authentication/provider/auth_provider.dart';

class UpdateProfileProvider extends ChangeNotifier {
  final UpdateProfileRepo _profileRepo = UpdateProfileRepo();
  bool isLoading = false;

  Future<void> updateProfile(BuildContext context,
      {required String userId,
      String? userName,
      String? userBio,
      String? userNumber,
      String? userImage}) async {
    try {
      isLoading = true;
      notifyListeners();
      if (userName != null) {
        await _profileRepo.updateUserName(userId, userName);
      }
      if (userBio != null) {
        await _profileRepo.updateUserBio(userId, userBio);
      }
      if (userNumber != null) {
        await _profileRepo.updateUserNumber(userId, userNumber);
      }
      if (userImage != null) {
        await _profileRepo.updateUserImage(userId, userImage);
      }
      if (userName != null ||
          userBio != null ||
          userImage != null ||
          userNumber != null) {
        await context.read<AuthProvider>().getUser(
            await context.read<AuthProvider>().authUserModel!.userPhoneNumber);
      }
      isLoading = false;
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
}
