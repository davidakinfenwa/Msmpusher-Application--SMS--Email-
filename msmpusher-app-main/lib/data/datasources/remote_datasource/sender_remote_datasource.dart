import 'package:dio/dio.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class SenderRemoteDataSource {
  Future<ResponseModel<SenderIdList>> getSenderIds({
    required GetAccountDetailsFormParams getAccountDetailsFormParams,
  });
  Future<ResponseModel<SenderIdList>> createSenderId({
    required CreateSenderIdFormParams createSenderIdFormParams,
  });
  Future<ResponseModel<SenderIdList>> deleteSenderId({
    required DeleteSenderIdFormParams deleteSenderIdFormParams,
  });
}

class SenderRemoteDataSourceImpl implements SenderRemoteDataSource {
  final ExceptionMapper _exceptionMapper;

  SenderRemoteDataSourceImpl({required ExceptionMapper exceptionMapper})
      : _exceptionMapper = exceptionMapper;

  @override
  Future<ResponseModel<SenderIdList>> getSenderIds(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/senderID/view',
        queryParameters: getAccountDetailsFormParams.toJson(),
      );

      if (!(_response.data['response'] as bool)) {
        return ResponseModel<SenderIdList>.errorResponse(
          data: GenericResponseModel.fromJson(_response.data),
        );
      }

      return ResponseModel<SenderIdList>.successResponse(
          data: SenderIdList.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<ResponseModel<SenderIdList>> createSenderId(
      {required CreateSenderIdFormParams createSenderIdFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/senderID/register',
        queryParameters: createSenderIdFormParams.toJson(),
      );

      if (!(_response.data['response'] as bool)) {
        return ResponseModel<SenderIdList>.errorResponse(
          data: GenericResponseModel.fromJson(_response.data),
        );
      }

      return ResponseModel<SenderIdList>.successResponse(
          data: SenderIdList.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<ResponseModel<SenderIdList>> deleteSenderId(
      {required DeleteSenderIdFormParams deleteSenderIdFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/senderID/delete',
        queryParameters: deleteSenderIdFormParams.toJson(),
      );

      if (!(_response.data['response'] as bool)) {
        return ResponseModel<SenderIdList>.errorResponse(
          data: GenericResponseModel.fromJson(_response.data),
        );
      }

      return ResponseModel<SenderIdList>.successResponse(
          data: SenderIdList.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }
}
