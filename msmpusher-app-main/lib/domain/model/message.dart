// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';

class MessageInfo extends Equatable {
  final String messageId;
  final String message;
  final int messagePage;
  final String senderName;
  final List<String> receivers;
  final String totalReceivers;
  final bool sendingComplete;
  final int numbToBeSent;
  final String totalCharge;
  final DateTime dateSent;

  String get status => sendingComplete ? 'COMPLETED' : 'PENDING';
  Color get statusForegroundColor => sendingComplete
      ? CustomTypography.kIndicationColor
      : CustomTypography.kMidGreyColor;
  Color get statusBackgroundColor => sendingComplete
      ? CustomTypography.kIndicationColor10
      : CustomTypography.kLightGreyColor;

  int get RECIPIENT_LENGTH => receivers.length;

  const MessageInfo({
    required this.messageId,
    required this.message,
    required this.messagePage,
    required this.senderName,
    required this.receivers,
    required this.totalReceivers,
    required this.sendingComplete,
    required this.numbToBeSent,
    required this.totalCharge,
    required this.dateSent,
  });

  factory MessageInfo.fromJson(Map<String, dynamic> json) {
    return MessageInfo(
      messageId: json['msgid'],
      message: json['msg'],
      messagePage: json['msg_page'],
      senderName: json['sendername'],
      receivers: json['receivers'] == null
          ? []
          : (json['receivers'] as String).split(','),
      totalReceivers: json['total_receivers'],
      sendingComplete: json['sending_complete'],
      numbToBeSent: json['numb_to_be_sent'],
      totalCharge: json['total_charge'],
      dateSent: DateTime.parse(json['date_sent']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msgid': messageId,
      'msg': message,
      'msg_page': messagePage,
      'sendername': senderName,
      'receivers': receivers.join(','),
      'total_receivers': totalReceivers,
      'sending_complete': sendingComplete,
      'numb_to_be_sent': numbToBeSent,
      'total_charge': totalCharge,
      'date_sent': dateSent.toString(),
    };
  }

  @override
  List<Object> get props {
    return [
      messageId,
      message,
      messagePage,
      senderName,
      receivers,
      sendingComplete,
      numbToBeSent,
      totalCharge,
      dateSent,
    ];
  }

  @override
  String toString() {
    return 'Message(messageId: $messageId, message: $message, messagePage: $messagePage, senderName: $senderName, receivers: $receivers, sendingComplete: $sendingComplete, numbToBeSent: $numbToBeSent, totalCharge: $totalCharge, dateSent: $dateSent)';
  }
}

class MessageInfoList extends Equatable {
  final List<MessageInfo> messages;

  bool get IS_EMPTY => messages.isEmpty;
  int get LENGTH => messages.length;
  MessageInfo get SINGLE => messages.first;

  const MessageInfoList({required this.messages});

  factory MessageInfoList.empty() {
    return const MessageInfoList(messages: []);
  }

  factory MessageInfoList.fromJson(Map<String, dynamic> json) {
    return MessageInfoList(
      messages: (json['message_info'] as List)
          .map((e) => MessageInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_info': messages.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [messages];

  @override
  String toString() => 'MessageList(messages: $messages)';
}
