import 'package:equatable/equatable.dart';

class DeleteSenderIdFormParams extends Equatable {
  final String sid;
  final String userId;
  final String accountNumber;

  const DeleteSenderIdFormParams({
    required this.sid,
    required this.userId,
    required this.accountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'uid': userId,
      'uacctno': accountNumber,
    };
  }

  @override
  List<Object> get props => [sid, userId, accountNumber];

  @override
  String toString() =>
      'DeleteSenderIdFormParams(sid: $sid, userId: $userId, accountNumber: $accountNumber)';
}
