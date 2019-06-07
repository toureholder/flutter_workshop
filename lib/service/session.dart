import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';
import 'package:meta/meta.dart';

import 'session_provider.dart';

class Session implements SessionProvider {
  final DiskStorageProvider diskStorageProvider;

  Session({@required this.diskStorageProvider});

  @override
  Future<List<bool>> logUserIn(LoginResponse loginResponse) => Future.wait([
    diskStorageProvider.setUser(loginResponse.user),
    diskStorageProvider.setAccessToken(loginResponse.token)
  ]);

  @override
  Future<List<bool>> logUserOut() => Future.wait([
    diskStorageProvider.clearUser(),
    diskStorageProvider.clearToken()
  ]);
}