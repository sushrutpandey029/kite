import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/url_constants.dart';

class DellAccountRepo {
  final String _kiteApi = '$baseUrl/Kiteapi_controller';

  Future<void> delAccount(String userId) async {
    String path = '$_kiteApi/acct_delete';
    try {
      Response response = await Dio().post(path, data: {"user_id": userId});

      print(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<void> delAccountReasons(String userReg, String userName,
      String userNumber, String delReason) async {
    String path = '$_kiteApi/delete_reasons';
    try {
      Response response = await Dio().post(path, data: {
        "user_id": userReg,
        "update_username": userName,
        "user_number": userNumber,
        "delete_reasons": delReason
      });

      print(response.data);
    } on DioError {
      rethrow;
    }
  }
}
