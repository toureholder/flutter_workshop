import 'package:flutter_workshop/model/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final User user;
  @JsonKey(name: 'long_lived_token')
  final String token;

  LoginResponse(this.token, this.user);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
