import 'package:equatable/equatable.dart';

class GetAccountDetailsFormParams extends Equatable {
  final String userId;
  final String accountNumber;

  const GetAccountDetailsFormParams(
      {required this.userId, required this.accountNumber});

  Map<String, dynamic> toJson() {
    return {
      'uid': userId,
      'uacctno': accountNumber,
    };
  }

  @override
  List<Object> get props => [userId, accountNumber];

  @override
  String toString() =>
      'GetAccountBalanceFormParams(userId: $userId, accountNumber: $accountNumber)';
}
