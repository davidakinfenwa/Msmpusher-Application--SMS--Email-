// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String uid;
  final String? accountNumber;
  final String firstName;
  final String? lastName;
  final String? email;
  final String phoneNumber;
  final String phoneNumberFull;
  final String? countryCode;
  final String? countryName;
  final String? countryCurrency;

  // static value to hold success code for auth-registration endpoint
  static int get SUCCESS_RESPONSE_CODE => 4;

  const UserInfo({
    required this.uid,
    required this.accountNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.phoneNumberFull,
    required this.countryCode,
    required this.countryName,
    required this.countryCurrency,
  });

  factory UserInfo.empty() {
    return const UserInfo(
      uid: '',
      accountNumber: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNumber: '',
      phoneNumberFull: '',
      countryCode: '',
      countryName: '',
      countryCurrency: '',
    );
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      uid: json['uid'],
      accountNumber: json['acct_no'],
      firstName: json['f_name'],
      lastName: json['l_name'],
      email: json['email'],
      phoneNumber: json['p_number'],
      phoneNumberFull: json['p_number_full'],
      countryCode: json['country_code'],
      countryName: json['country_name'],
      countryCurrency: json['country_currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'acct_no': accountNumber,
      'f_name': firstName,
      'l_name': lastName,
      'email': email,
      'p_number': phoneNumber,
      'p_number_full': phoneNumberFull,
      'country_code': countryCode,
      'country_name': countryName,
      'country_currency': countryCurrency,
    };
  }

  @override
  List<Object> get props {
    return [
      uid,
      accountNumber!,
      firstName,
      lastName!,
      email!,
      phoneNumber,
      phoneNumberFull,
      countryCode!,
      countryName!,
      countryCurrency!,
    ];
  }

  @override
  String toString() {
    return 'UserInfo(uid: $uid, accountNumber: $accountNumber, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, phoneNumberFull: $phoneNumberFull, countryCode: $countryCode, countryName: $countryName, countryCurrency: $countryCurrency)';
  }
}

class UserInfoModel extends Equatable {
  final bool response;
  final String message;
  final List<UserInfo> userInfo;
  final int responseNumber;

  bool get hasUserInfo => userInfo.isNotEmpty;
  UserInfo get user => userInfo.first;

  // sign-in navigation-action cases
  bool get VERIFY_ACCOUNT => responseNumber == 6;
  bool get SIGN_IN_SUCCESSFUL => responseNumber == 7;

  // sign-up navigation-action case
  bool get SIGN_UP_SUCCESSFUL => responseNumber == 4;

  // initializing user-profile after login or sign-up
  bool get USER_PROFILE_SUCCESSFUL => responseNumber == 2;

  const UserInfoModel({
    required this.response,
    required this.message,
    required this.userInfo,
    required this.responseNumber,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      response: json['response'],
      message: json['message'],
      userInfo: (json['user_info'] as List)
          .map((e) => UserInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      responseNumber: json['response_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'user_info': userInfo.map((e) => e.toJson()).toList(),
      'message': message,
      'response_no': responseNumber,
    };
  }

  @override
  List<Object> get props => [response, message, userInfo, responseNumber];

  @override
  String toString() {
    return 'UserInfoModel(response: $response, message: $message, userInfo: $userInfo, responseNumber: $responseNumber)';
  }
}
