import 'package:equatable/equatable.dart';

import 'package:msmpusher/domain/model/models.dart';

class AccountSMSMetric extends Equatable {
  final num totalSMSSentAll;
  final num totalSMSSentToday;

  const AccountSMSMetric(
      {required this.totalSMSSentAll, required this.totalSMSSentToday});

  factory AccountSMSMetric.empty() {
    return const AccountSMSMetric(
      totalSMSSentAll: 0,
      totalSMSSentToday: 0,
    );
  }

  factory AccountSMSMetric.fromJson(Map<String, dynamic> json) {
    final _account = json['sms_details'][0];

    return AccountSMSMetric(
      totalSMSSentAll: _account['Total_sms_sent_all'],
      totalSMSSentToday: _account['Total_sms_sent_today'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sms_details': [
        {
          'Total_sms_sent_all': totalSMSSentAll,
          'Total_sms_sent_today': totalSMSSentToday,
        },
      ],
    };
  }

  @override
  List<Object> get props => [totalSMSSentAll, totalSMSSentToday];

  @override
  String toString() =>
      'SMSMetric(totalSMSSentAll: $totalSMSSentAll, totalSMSSentToday: $totalSMSSentToday)';
}

// TODO: add sender-id count to metrics
class AccountMetric extends Equatable {
  final AccountSMSMetric accountSmsMetric;
  final ContactModelList contactModelList;
  final ContactGroupList contactGroupList;

  const AccountMetric({
    required this.accountSmsMetric,
    required this.contactModelList,
    required this.contactGroupList,
  });

  factory AccountMetric.empty() {
    return AccountMetric(
      accountSmsMetric: AccountSMSMetric.empty(),
      contactModelList: ContactModelList.empty(),
      contactGroupList: ContactGroupList.empty(),
    );
  }

  factory AccountMetric.fromJson(Map<String, dynamic> json) {
    return AccountMetric(
      accountSmsMetric: AccountSMSMetric.fromJson(json),
      contactModelList: ContactModelList.empty(),
      contactGroupList: ContactGroupList.empty(),
    );
  }

  AccountMetric copyWith({
    AccountSMSMetric? accountSmsMetric,
    ContactModelList? contactModelList,
    ContactGroupList? contactGroupList,
  }) {
    return AccountMetric(
      accountSmsMetric: accountSmsMetric ?? this.accountSmsMetric,
      contactModelList: contactModelList ?? this.contactModelList,
      contactGroupList: contactGroupList ?? this.contactGroupList,
    );
  }

  @override
  List<Object> get props =>
      [accountSmsMetric, contactModelList, contactGroupList];

  @override
  String toString() =>
      'AccountMetric(accountSmsMetric: $accountSmsMetric, contactModelList: $contactModelList, contactGroupList: $contactGroupList)';
}
