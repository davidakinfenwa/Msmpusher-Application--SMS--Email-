import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_model.freezed.dart';

@freezed
class ResponseModel<T> with _$ResponseModel<T> {
  const factory ResponseModel.successResponse({required T data}) =
      SuccessResponse;
  const factory ResponseModel.errorResponse(
      {required GenericResponseModel data}) = ErrorResponse;
}

class GenericResponseModel extends Equatable {
  final bool response;
  final String message;
  final int responseNumber;

  const GenericResponseModel({
    required this.response,
    required this.message,
    required this.responseNumber,
  });

  factory GenericResponseModel.fromJson(Map<String, dynamic> json) {
    return GenericResponseModel(
      response: json['response'],
      message: json['message'],
      responseNumber: json['response_no'],
    );
  }

  @override
  List<Object> get props => [response, message, responseNumber];

  @override
  String toString() {
    return 'GenericResponseModel(response: $response, message: $message, responseNumber: $responseNumber)';
  }
}
