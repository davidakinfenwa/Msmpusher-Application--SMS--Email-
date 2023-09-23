// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class SenderIdApproval {
  static const PENDING = 'PENDING';
  static const APPROVED = 'APPROVED';
  static const REJECTED = 'REJECTED';
}

class SenderId extends Equatable {
  final String sId;
  final String senderId;
  final String approval;
  final DateTime created;

  String get label => approval == 1.toString()
      ? SenderIdApproval.APPROVED
      : approval == 3.toString()
          ? SenderIdApproval.REJECTED
          : SenderIdApproval.PENDING;

  Color get indicatorColor {
    if (label == SenderIdApproval.APPROVED) {
      return CustomTypography.kIndicationColor;
    }
    if (label == SenderIdApproval.REJECTED) {
      return CustomTypography.kIndicationColor;
    }

    return CustomTypography.kBlackColor;
  }

  Color get backgroundColor {
    if (label == SenderIdApproval.APPROVED) {
      return CustomTypography.kIndicationColor10;
    }
    if (label == SenderIdApproval.REJECTED) {
      return CustomTypography.kIndicationColor10;
    }

    return CustomTypography.kLightGreyColor;
  }

  const SenderId({
    required this.sId,
    required this.senderId,
    required this.approval,
    required this.created,
  });

  factory SenderId.fromJson(Map<String, dynamic> json) {
    return SenderId(
      sId: json['sid'],
      senderId: json['senderid'],
      approval: json['approval'],
      created: DateTime.parse(json['date_reg'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sid': sId,
      'senderid': senderId,
      'approval': approval,
      'date_reg': created.toString(),
    };
  }

  @override
  List<Object> get props => [sId, senderId, approval, created];

  @override
  String toString() {
    return 'SenderId(sId: $sId, senderId: $senderId, approval: $approval, created: $created)';
  }
}

class SenderIdList extends Equatable {
  final List<SenderId> senderIds;

  const SenderIdList({required this.senderIds});

  factory SenderIdList.empty() {
    return const SenderIdList(senderIds: []);
  }

  factory SenderIdList.fromJson(Map<String, dynamic> json) {
    final _jsonList = json['senderIDList'] as List;

    return SenderIdList(
      senderIds: _jsonList.map((e) => SenderId.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'senderIDList': senderIds.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object> get props => [senderIds];

  @override
  String toString() => 'SenderIdList(senderIds: $senderIds)';
}
