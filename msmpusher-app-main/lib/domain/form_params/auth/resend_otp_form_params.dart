import 'package:equatable/equatable.dart';

class ResendOtpFormParams extends Equatable {
  final String phoneNumber;

  const ResendOtpFormParams({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'u_key': phoneNumber,
    };
  }

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'ResendOtpFormParams(phoneNumber: $phoneNumber)';
}
