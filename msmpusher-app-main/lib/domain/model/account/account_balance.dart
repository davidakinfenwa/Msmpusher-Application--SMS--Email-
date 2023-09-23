import 'package:equatable/equatable.dart';

class AccountBalance extends Equatable {
  final num unitBalance;
  final num walletBalance;

  const AccountBalance(
      {required this.unitBalance, required this.walletBalance});

  factory AccountBalance.empty() {
    return const AccountBalance(
      unitBalance: 0,
      walletBalance: 0.0,
    );
  }

  factory AccountBalance.fromJson(Map<String, dynamic> json) {
    final _account = json['acct_details'][0];

    return AccountBalance(
      unitBalance: _account['unit_balance'],
      walletBalance: _account['wallet_balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acct_details': [
        {
          'unit_balance': unitBalance,
          'wallet_balance': walletBalance,
        },
      ],
    };
  }

  @override
  List<Object> get props => [unitBalance, walletBalance];

  @override
  String toString() =>
      'AccountBalance(unitBalance: $unitBalance, walletBalance: $walletBalance)';
}
