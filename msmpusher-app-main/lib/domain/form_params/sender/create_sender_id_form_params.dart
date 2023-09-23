import 'package:equatable/equatable.dart';

class CreateSenderIdFormParams extends Equatable {
  final String userId;
  final String senderName;
  final String accountNumber;

  const CreateSenderIdFormParams({
    required this.userId,
    required this.senderName,
    required this.accountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': userId,
      'sendername': senderName,
      'uacctno': accountNumber,
    };
  }

  @override
  List<Object> get props => [userId, senderName, accountNumber];

  @override
  String toString() =>
      'CreateSenderIdFormParams(userId: $userId, senderName: $senderName, accountNumber: $accountNumber)';
}
