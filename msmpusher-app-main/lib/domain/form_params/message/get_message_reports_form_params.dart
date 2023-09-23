import 'package:equatable/equatable.dart';

import 'package:msmpusher/domain/model/models.dart';

class GetMessageReportsFormParams extends Equatable {
  final UserInfo userInfo;

  const GetMessageReportsFormParams({required this.userInfo});

  Map<String, dynamic> toJson() {
    return {
      'uid': userInfo.uid,
      'uacctno': userInfo.accountNumber,
    };
  }

  @override
  List<Object> get props => [userInfo];

  @override
  String toString() => 'GetMessageReportsFormParams(userInfo: $userInfo)';
}
