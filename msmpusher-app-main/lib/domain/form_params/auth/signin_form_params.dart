import 'package:equatable/equatable.dart';

class SignInFromParams extends Equatable {
  final String phoneNumber;
  final String password;

  const SignInFromParams({
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'u_key': phoneNumber,
      'p_key': password,
    };
  }

  @override
  List<Object> get props => [phoneNumber, password];

  @override
  String toString() =>
      'SignInFromParams(phoneNumber: $phoneNumber, password: $password)';
}
