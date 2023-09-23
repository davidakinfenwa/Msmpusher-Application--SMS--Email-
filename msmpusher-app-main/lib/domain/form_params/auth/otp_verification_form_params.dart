import 'package:equatable/equatable.dart';

// @freezed
// class OtpVerificationFromParams with _$OtpVerificationFromParams {
//   const factory OtpVerificationFromParams.signupForm({
//     required SignupOtpVerificationFormParams signupOtpVerificationFormParams,
//   }) = _SignupForm;
//   const factory OtpVerificationFromParams.forgotPasswordForm({
//     required ForgotPasswordOtpVerificationFormParams
//         forgotPasswordOtpVerificationFormParams,
//   }) = _ForgotPasswordForm;
// }

class SignupOtpVerificationFormParams extends Equatable {
  final String uid;
  final String otpCode;

  const SignupOtpVerificationFormParams(
      {required this.uid, required this.otpCode});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'otp_key': otpCode,
    };
  }

  @override
  List<Object> get props => [uid, otpCode];

  @override
  String toString() =>
      'SignupOtpVerificationFormParams(uid: $uid, otpCode: $otpCode)';
}

class ForgotPasswordOtpVerificationFormParams extends Equatable {
  final String otpCode;
  final String phoneNumber;

  const ForgotPasswordOtpVerificationFormParams(
      {required this.otpCode, required this.phoneNumber});

  // auth-key will be added in the data-layer
  Map<String, dynamic> toJson() {
    return {
      'otp_key': otpCode,
      'u_key': phoneNumber,
    };
  }

  @override
  List<Object> get props => [otpCode, phoneNumber];

  @override
  String toString() =>
      'ForgotPasswordOtpVerificationFormParams(otpCode: $otpCode, phoneNumber: $phoneNumber)';
}
