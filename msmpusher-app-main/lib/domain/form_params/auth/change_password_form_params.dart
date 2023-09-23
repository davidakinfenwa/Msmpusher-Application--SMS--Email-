import 'package:equatable/equatable.dart';

class ChangePasswordFormParams extends Equatable {
  final String phoneNumber;
  final String newPassword;

  const ChangePasswordFormParams({
    required this.phoneNumber,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'u_key': phoneNumber,
      'new_p': newPassword,
    };
  }

  @override
  List<Object> get props => [phoneNumber, newPassword];

  @override
  String toString() =>
      'ChangePasswordFormParams(phoneNumber: $phoneNumber, newPassword: $newPassword)';
}
