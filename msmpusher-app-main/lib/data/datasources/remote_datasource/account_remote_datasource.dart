import 'package:dio/dio.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class AccountRemoteDataSource {
  Future<ResponseModel<AccountBalance>> getAccountBalance(
      {required GetAccountDetailsFormParams getAccountDetailsFormParams});
  Future<ResponseModel<AccountMetric>> getAccountMetrics(
      {required GetAccountDetailsFormParams getAccountDetailsFormParams});
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ExceptionMapper _exceptionMapper;

  AccountRemoteDataSourceImpl({required ExceptionMapper exceptionMapper})
      : _exceptionMapper = exceptionMapper;

  @override
  Future<ResponseModel<AccountBalance>> getAccountBalance(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/user/account-details',
        queryParameters: getAccountDetailsFormParams.toJson(),
      );

      if (!(_response.data['response'] as bool)) {
        return ResponseModel<AccountBalance>.errorResponse(
          data: GenericResponseModel.fromJson(_response.data),
        );
      }

      return ResponseModel<AccountBalance>.successResponse(
          data: AccountBalance.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<ResponseModel<AccountMetric>> getAccountMetrics(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/user/sms-details',
        queryParameters: getAccountDetailsFormParams.toJson(),
      );

      if (!(_response.data['response'] as bool)) {
        return ResponseModel<AccountMetric>.errorResponse(
          data: GenericResponseModel.fromJson(_response.data),
        );
      }

      return ResponseModel<AccountMetric>.successResponse(
          data: AccountMetric.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }
}
