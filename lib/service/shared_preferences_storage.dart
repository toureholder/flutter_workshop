import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _userKey = 'user';
const String _accessTokenKey = 'accesToken';

class SharedPreferencesStorage implements DiskStorageProvider {
  SharedPreferencesStorage(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  User getUser() {
    try {
      return User.fromEncodedJson(sharedPreferences.getString(_userKey));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setUser(User user) =>
      sharedPreferences.setString(_userKey, user.toEncodedJson());

  @override
  String getAccessToken() => sharedPreferences.getString(_accessTokenKey);

  @override
  Future<bool> setAccessToken(String token) =>
      sharedPreferences.setString(_accessTokenKey, token);

  @override
  Future<bool> clearToken() => sharedPreferences.remove(_accessTokenKey);

  @override
  Future<bool> clearUser() => sharedPreferences.remove(_userKey);
}
