import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/service/disk_storage_provider.dart';

import 'session_provider.dart';

class Session implements SessionProvider {
  Session({required this.diskStorageProvider});

  final DiskStorageProvider diskStorageProvider;

  @override
  Future<List<bool>> logUserIn(
    String? token,
    User user,
  ) =>
      Future.wait(
        <Future<bool>>[
          diskStorageProvider.setAccessToken(token),
          diskStorageProvider.setUser(user),
        ],
      );

  @override
  Future<List<bool>> logUserOut() => Future.wait(<Future<bool>>[
        diskStorageProvider.clearUser(),
        diskStorageProvider.clearToken()
      ]);
}
