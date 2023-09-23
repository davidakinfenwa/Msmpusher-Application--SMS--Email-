import 'package:flutter/material.dart';
import 'package:msmpusher/domain/model/models.dart';

class AccountDetailsSnapshotCache with ChangeNotifier {
  static AccountMetric? _accountMetric;
  static AccountBalance? _accountBalance;

  AccountMetric get accountMetric => _accountMetric ?? AccountMetric.empty();
  set accountMetric(AccountMetric metric) {
    _accountMetric = metric;
    notifyListeners();
  }

  AccountBalance get accountBalance =>
      _accountBalance ?? AccountBalance.empty();
  set accountBalance(AccountBalance balance) {
    _accountBalance = balance;
    notifyListeners();
  }

  void notifyAllListeners() {
    notifyListeners();
  }
}
