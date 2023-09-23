import 'package:equatable/equatable.dart';

import 'package:msmpusher/domain/model/models.dart';

class SendMessageFormParams extends Equatable {
  final String senderId;
  final UserInfo userInfo;
  final List<String> numbers;
  final String message;

  const SendMessageFormParams({
    required this.senderId,
    required this.userInfo,
    required this.numbers,
    required this.message,
  });

  // TODO: refactor numbers to list (when reviewed)
  Map<String, dynamic> toJson() {
    return {
      'uid': userInfo.uid,
      'sendername': senderId,
      'uacctno': userInfo.accountNumber,
      'numbers': numbers.join(','),
      'message': message,
    };
  }

  @override
  List<Object> get props => [senderId, userInfo, numbers, message];

  @override
  String toString() {
    return 'SendMessageFormParams(senderId: $senderId, userInfo: $userInfo, numbers: $numbers, message: $message)';
  }
}
