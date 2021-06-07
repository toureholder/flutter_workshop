import 'package:flutter_workshop/model/user/user.dart';

abstract class DiskStorageProvider {
  Future<bool> setUser(User user);
  User? getUser();
  Future<bool> clearUser();
  Future<bool> setAccessToken(String? token);
  String? getAccessToken();
  Future<bool> clearToken();
}
