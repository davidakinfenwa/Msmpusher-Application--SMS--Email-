import 'package:dio/dio.dart';
import 'package:msmpusher/core/exceptions/exception_mapper.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';

abstract class AuthRemoteDataSource {
  Future<UserInfoModel> signup({required SignUpFromParams signUpFromParams});

  Future<UserInfoModel> signin({required SignInFromParams signInFromParams});

  Future<UserInfoModel> getUserProfile(
      {required UserProfileFormParams userProfileFormParams});

  Future<ResponseModel<AuthKeyModel>> forgotPassword(
      {required ForgotPasswordFormParams forgotPasswordFormParams});

  Future<GenericResponseModel> verifyPasswordResetOTPCode({
    required AuthKeyModel authKeyModel,
    required ForgotPasswordOtpVerificationFormParams
        forgotPasswordOtpVerificationFormParams,
  });

  Future<GenericResponseModel> changePassword({
    required AuthKeyModel authKeyModel,
    required ChangePasswordFormParams changePasswordFormParams,
  });

  Future<ResponseModel<GenericResponseModel>> verifySignupOTPCode({
    required SignupOtpVerificationFormParams signupOtpVerificationFormParams,
  });
  Future<GenericResponseModel> resendOTPVerificationCode({
    required ResendOtpFormParams resendOtpFormParams,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ExceptionMapper _exceptionMapper;

  AuthRemoteDataSourceImpl({required ExceptionMapper exceptionMapper})
      : _exceptionMapper = exceptionMapper;

  @override
  Future<UserInfoModel> signup(
      {required SignUpFromParams signUpFromParams}) async {
    try {
      final _response = await dioClient.get(
        '/auth/register',
        queryParameters: signUpFromParams.toJson(),
      );

      return UserInfoModel.fromJson(_response.data);
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<UserInfoModel> signin(
      {required SignInFromParams signInFromParams}) async {
    try {
      final _response = await dioClient.get(
        '/auth/login',
        queryParameters: signInFromParams.toJson(),
      );

      return UserInfoModel.fromJson(_response.data);
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<UserInfoModel> getUserProfile(
      {required UserProfileFormParams userProfileFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/user/profile',
        queryParameters: userProfileFormParams.toJson(),
      );

      return UserInfoModel.fromJson(_response.data);
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<ResponseModel<AuthKeyModel>> forgotPassword(
      {required ForgotPasswordFormParams forgotPasswordFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/auth/forgot',
        queryParameters: forgotPasswordFormParams.toJson(),
      );

      if (_response.data['response'] == false) {
        return ResponseModel.errorResponse(
            data: GenericResponseModel.fromJson(_response.data));
      }

      return ResponseModel.successResponse(
          data: AuthKeyModel.fromJson(_response.data));
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<GenericResponseModel> verifyPasswordResetOTPCode({
    required AuthKeyModel authKeyModel,
    required ForgotPasswordOtpVerificationFormParams
        forgotPasswordOtpVerificationFormParams,
  }) async {
    try {
      final _updatedFormParams =
          forgotPasswordOtpVerificationFormParams.toJson();

      // add auth-key to form params
      _updatedFormParams.addEntries(authKeyModel.toJson().entries);

      final _response = await dioClient.get(
        '/auth/forgot_verify',
        queryParameters: _updatedFormParams,
      );

      return GenericResponseModel.fromJson(_response.data);
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<GenericResponseModel> changePassword({
    required AuthKeyModel authKeyModel,
    required ChangePasswordFormParams changePasswordFormParams,
  }) async {
    try {
      final _updatedFormParams = changePasswordFormParams.toJson();

      // add auth-key to form params
      _updatedFormParams.addEntries(authKeyModel.toJson().entries);

      final _response = await dioClient.get(
        '/auth/change_password',
        queryParameters: _updatedFormParams,
      );

      return GenericResponseModel.fromJson(_response.data);
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<ResponseModel<GenericResponseModel>> verifySignupOTPCode({
    required SignupOtpVerificationFormParams signupOtpVerificationFormParams,
  }) async {
    try {
      final _response = await dioClient.get(
        '/auth/otp_checker',
        queryParameters: signupOtpVerificationFormParams.toJson(),
      );

      if (_response.data['response'] == false) {
        return ResponseModel.errorResponse(
            data: GenericResponseModel.fromJson(_response.data));
      }

      return ResponseModel.successResponse(
        data: GenericResponseModel.fromJson(_response.data),
      );
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }

  @override
  Future<GenericResponseModel> resendOTPVerificationCode(
      {required ResendOtpFormParams resendOtpFormParams}) async {
    try {
      final _response = await dioClient.get(
        '/auth/resend_otp',
        queryParameters: resendOtpFormParams.toJson(),
      );

      return GenericResponseModel.fromJson(_response.data);
    } on DioError catch (e) {
      throw _exceptionMapper.mapException(e);
    }
  }
}
