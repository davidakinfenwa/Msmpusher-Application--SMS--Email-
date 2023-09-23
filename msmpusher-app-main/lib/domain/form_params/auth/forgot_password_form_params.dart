import 'package:equatable/equatable.dart';

class ForgotPasswordFormParams extends Equatable {
  final String phoneNumber;

  const ForgotPasswordFormParams({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'u_key': phoneNumber,
    };
  }

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'ForgotPasswordFormParams(phoneNumber: $phoneNumber)';
}
