import 'package:flutter_workshop/model/login/login_response.dart';

abstract class SessionProvider {
  Future<List<bool>> logUserIn(LoginResponse loginResponse);
  Future<List<bool>> logUserOut();
}