import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';
import 'package:meta/meta.dart';

import 'session_provider.dart';

class Session implements SessionProvider {
  Session({@required this.diskStorageProvider});

  final DiskStorageProvider diskStorageProvider;

  @override
  Future<List<bool>> logUserIn(LoginResponse loginResponse) =>
      Future.wait(<Future<bool>>[
        diskStorageProvider.setUser(loginResponse.user),
        diskStorageProvider.setAccessToken(loginResponse.token)
      ]);

  @override
  Future<List<bool>> logUserOut() => Future.wait(<Future<bool>>[
        diskStorageProvider.clearUser(),
        diskStorageProvider.clearToken()
      ]);
}
