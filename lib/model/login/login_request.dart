import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  const LoginRequest({
    this.email,
    this.password,
  });

  final String? email;
  final String? password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [email, password];
}
