import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/database/hive_models/auth_hive_model.dart';

class Boxes {
  static Box<AuthHiveModel> getAuthHive() => Hive.box<AuthHiveModel>('Auth');
}
