import 'package:equatable/equatable.dart';

class UserProfileFormParams extends Equatable {
  final String userId;

  const UserProfileFormParams({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'uid': userId,
    };
  }

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'UserProfileFormParams(userId: $userId)';
}
