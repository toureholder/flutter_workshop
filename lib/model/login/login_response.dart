import 'package:flutter_workshop/model/user/user.dart';

class LoginResponse {
  LoginResponse(this.token, this.user);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : token = json['long_lived_token'],
        user = User.fromJson(json['user']);

  final User user;
  final String token;
}
