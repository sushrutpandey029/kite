import 'package:dio/dio.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/shared/constants/url_constants.dart';

class SettingsRepo {
  final String _kiteApi = '$baseUrl/Kiteapi_controller';

  Future<void> deleteAccount(String userId) async {
    String path = '$_kiteApi/acct_delete';
    try {
      Response response = await Dio().post(path, data: {"user_id": userId});

      print(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<void> deleteReason(AuthUserModel userModel) async {
    String path = '$_kiteApi/delete_reasons';
    try {
      FormData formData = FormData.fromMap({
        "user_reg_no": userModel.userRegNo,
        "user_name": userModel.userName,
        "user_number": userModel.userPhoneNumber,
        "deleted_region": userModel.country,
      });
      Response response = await Dio().post(path,
          data: formData,
          options: Options(
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
              headers: {'Connection': 'keep-alive'}));

      print(response.data);
    } on DioError {
      rethrow;
    }
  }
}
