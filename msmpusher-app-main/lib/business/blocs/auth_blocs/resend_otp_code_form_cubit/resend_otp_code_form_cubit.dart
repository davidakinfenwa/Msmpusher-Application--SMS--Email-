import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class ResendOtpCodeFormCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, GenericResponseModel>> {
  final AuthRepository _repository;

  ResendOtpCodeFormCubit({required AuthRepository repository})
      : _repository = repository,
        super(const BlocState<Failure<ExceptionMessage>,
            GenericResponseModel>.initial());

  Future<void> resendOTPVerificationCode(
      {required ResendOtpFormParams resendOtpFormParams}) async {
    emit(const BlocState<Failure<ExceptionMessage>,
        GenericResponseModel>.loading());

    final _resendOTPVerificationCodeEither = await _repository
        .resendOTPVerificationCode(resendOtpFormParams: resendOtpFormParams);

    final _state = _resendOTPVerificationCodeEither.fold(
      (failure) =>
          BlocState<Failure<ExceptionMessage>, GenericResponseModel>.error(
              failure: failure),
      (responseModel) {
        return BlocState<Failure<ExceptionMessage>,
            GenericResponseModel>.success(data: responseModel);
      },
    );

    emit(_state);
  }
}
