import 'package:equatable/equatable.dart';

class SignUpFromParams extends Equatable {
  final String fullName;
  final String phoneNumber;
  final String password;

  const SignUpFromParams({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'fname': fullName,
      'pnumber': phoneNumber,
      'password': password,
    };
  }

  @override
  List<Object> get props => [fullName, phoneNumber, password];

  @override
  String toString() =>
      'SignUpFromParams(fullName: $fullName, phoneNumber: $phoneNumber, password: $password)';
}
