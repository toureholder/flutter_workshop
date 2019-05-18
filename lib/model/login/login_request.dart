class LoginRequest {
  final String email;
  final String password;

  LoginRequest({this.email, this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
