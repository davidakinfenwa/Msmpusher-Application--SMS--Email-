import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class SignupFormCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, UserInfoModel>> {
  final AuthRepository _repository;
  final AuthSnapshotCache _snapshotCache;

  SignupFormCubit({
    required AuthRepository repository,
    required AuthSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            UserInfoModel>.initial());

  Future<void> signup({required SignUpFromParams signUpFromParams}) async {
    emit(const BlocState<Failure<ExceptionMessage>, UserInfoModel>.loading());

    final _signupEither =
        await _repository.signup(signUpFromParams: signUpFromParams);

    final _state = _signupEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, UserInfoModel>.error(
          failure: failure),
      (userInfoModel) {
        // cache snapshot
        if (userInfoModel.hasUserInfo) {
          _snapshotCache.userInfo = userInfoModel.user;
        }

        return BlocState<Failure<ExceptionMessage>, UserInfoModel>.success(
            data: userInfoModel);
      },
    );

    emit(_state);
  }
}
