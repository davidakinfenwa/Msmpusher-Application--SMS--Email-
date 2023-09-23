import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class SignupOtpVerificationFormCubit extends Cubit<
    BlocState<Failure<ExceptionMessage>, ResponseModel<GenericResponseModel>>> {
  final AuthRepository _repository;

  SignupOtpVerificationFormCubit({required AuthRepository repository})
      : _repository = repository,
        super(const BlocState<Failure<ExceptionMessage>,
            ResponseModel<GenericResponseModel>>.initial());

  Future<void> verifyOTPCode({
    required SignupOtpVerificationFormParams signupOtpVerificationFormParams,
  }) async {
    emit(const BlocState<Failure<ExceptionMessage>,
        ResponseModel<GenericResponseModel>>.loading());

    final _verifyOtpEither = await _repository.verifySignupOTPCode(
      signupOtpVerificationFormParams: signupOtpVerificationFormParams,
    );

    final _state = _verifyOtpEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>,
          ResponseModel<GenericResponseModel>>.error(failure: failure),
      (responseModel) {
        return BlocState<Failure<ExceptionMessage>,
            ResponseModel<GenericResponseModel>>.success(data: responseModel);
      },
    );

    emit(_state);
  }
}
