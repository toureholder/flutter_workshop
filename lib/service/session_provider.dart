import 'package:flutter_workshop/model/user/user.dart';

abstract class SessionProvider {
  Future<List<bool>> logUserIn(String token, User user);
  Future<List<bool>> logUserOut();
}
