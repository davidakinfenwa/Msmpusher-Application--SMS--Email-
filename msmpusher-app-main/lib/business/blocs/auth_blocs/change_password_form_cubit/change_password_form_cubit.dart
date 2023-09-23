import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class ChangePasswordFormCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, GenericResponseModel>> {
  final AuthRepository _repository;

  ChangePasswordFormCubit({required AuthRepository repository})
      : _repository = repository,
        super(const BlocState<Failure<ExceptionMessage>,
            GenericResponseModel>.initial());

  Future<void> changePassword({
    required ChangePasswordFormParams changePasswordFormParams,
  }) async {
    emit(const BlocState<Failure<ExceptionMessage>,
        GenericResponseModel>.loading());

    final _changePasswordEither = await _repository.changePassword(
        changePasswordFormParams: changePasswordFormParams);

    final _state = _changePasswordEither.fold(
      (failure) =>
          BlocState<Failure<ExceptionMessage>, GenericResponseModel>.error(
              failure: failure),
      (_) => BlocState<Failure<ExceptionMessage>, GenericResponseModel>.success(
          data: _),
    );

    emit(_state);
  }
}
