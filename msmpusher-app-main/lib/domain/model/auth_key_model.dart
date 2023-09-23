import 'package:equatable/equatable.dart';

class AuthKeyModel extends Equatable {
  final String authKey;

  const AuthKeyModel({required this.authKey});

  factory AuthKeyModel.empty() {
    return const AuthKeyModel(authKey: '');
  }

  factory AuthKeyModel.fromJson(Map<String, dynamic> json) {
    return AuthKeyModel(authKey: json['auth_key']);
  }

  Map<String, dynamic> toJson() {
    return {
      'auth_key': authKey,
    };
  }

  @override
  List<Object> get props => [authKey];

  @override
  String toString() => 'AuthKeyModel(authKey: $authKey)';
}
