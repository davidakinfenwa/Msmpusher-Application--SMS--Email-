import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class ForgotPasswordFormCubit extends Cubit<
    BlocState<Failure<ExceptionMessage>, ResponseModel<AuthKeyModel>>> {
  final AuthRepository _repository;
  final AuthSnapshotCache _snapshotCache;

  ForgotPasswordFormCubit({
    required AuthRepository repository,
    required AuthSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            ResponseModel<AuthKeyModel>>.initial());

  Future<void> forgotPassword(
      {required ForgotPasswordFormParams forgotPasswordFormParams}) async {
    emit(const BlocState<Failure<ExceptionMessage>,
        ResponseModel<AuthKeyModel>>.loading());

    final _forgotPasswordEither = await _repository.forgotPassword(
        forgotPasswordFormParams: forgotPasswordFormParams);

    final _state = _forgotPasswordEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>,
          ResponseModel<AuthKeyModel>>.error(failure: failure),
      (responseModel) {
        // cache snapshot
        _snapshotCache.authKeyModel = responseModel.maybeMap(
          orElse: () => AuthKeyModel.empty(),
          successResponse: (state) => state.data,
        );

        return BlocState<Failure<ExceptionMessage>,
            ResponseModel<AuthKeyModel>>.success(data: responseModel);
      },
    );

    emit(_state);
  }
}
