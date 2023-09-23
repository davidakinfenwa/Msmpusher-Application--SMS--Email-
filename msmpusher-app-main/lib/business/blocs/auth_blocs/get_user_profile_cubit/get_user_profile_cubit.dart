import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class GetUserProfileCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, UserInfoModel>> {
  final AuthRepository _repository;
  final AuthSnapshotCache _snapshotCache;

  GetUserProfileCubit({
    required AuthRepository repository,
    required AuthSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            UserInfoModel>.initial());

  Future<void> getUserProfile() async {
    emit(const BlocState<Failure<ExceptionMessage>, UserInfoModel>.loading());

    final _userProfileEither = await _repository.getUserProfile();

    final _state = _userProfileEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, UserInfoModel>.error(
          failure: failure),
      (userProfile) {
        // cache snapshot
        if (userProfile.hasUserInfo) {
          _snapshotCache.userInfo = userProfile.user;
        }

        return BlocState<Failure<ExceptionMessage>, UserInfoModel>.success(
            data: userProfile);
      },
    );

    emit(_state);
  }
}
