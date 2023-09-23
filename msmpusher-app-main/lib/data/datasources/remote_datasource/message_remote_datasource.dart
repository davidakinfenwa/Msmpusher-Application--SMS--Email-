
import 'package:dio/dio.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class MessageRemoteDataSource {
  Future<ResponseModel<MessageInfoList>> getMessageReports(
      {required GetMessageReportsFormParams getMessageReportsFormParams});
  Future<ResponseModel<MessageInfoList>> sendMessage(
      {required SendMessageFormParams sendMessageFormParams});
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final ExceptionMapper _exceptionMapper;

  MessageRemoteDataSourceImpl({required ExceptionMapper exceptionMapper})
      : _exceptionMapper = exceptionMapper;

  @override
  Future<ResponseModel<MessageInfoList>> getMessageReports(
      {required GetMessageReportsFormParams
          getMessageReportsFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/messaging/transaction',
        queryParameters: getMessageReportsFormParams.toJson(),
      );

      if (!(_response.data['response'] as bool)) {
        return ResponseModel<MessageInfoList>.errorResponse(
          data: GenericResponseModel.fromJson(_response.data),
        );
      }

      return ResponseModel<MessageInfoList>.successResponse(
          data: MessageInfoList.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<ResponseModel<MessageInfoList>> sendMessage(
      {required SendMessageFormParams sendMessageFormParams}) async {
    try {
      final _response = await dioClient.post(
        '/messaging/send',
        data: FormData.fromMap(sendMessageFormParams.toJson()),
      );

      if (!(_response.data['response'] as bool)) {
        return ResponseModel<MessageInfoList>.errorResponse(
          data: GenericResponseModel.fromJson(_response.data),
        );
      }

      return ResponseModel<MessageInfoList>.successResponse(
          data: MessageInfoList.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }
}
