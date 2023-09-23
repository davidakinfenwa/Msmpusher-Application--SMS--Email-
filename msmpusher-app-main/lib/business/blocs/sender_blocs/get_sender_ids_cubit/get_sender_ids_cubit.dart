import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class GetSenderIdsCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, SenderIdList>> {
  final SenderRepository _repository;
  final SenderSnapshotCache _snapshotCache;

  GetSenderIdsCubit({
    required SenderRepository repository,
    required SenderSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(
            const BlocState<Failure<ExceptionMessage>, SenderIdList>.initial());

  Future<BlocState<Failure<ExceptionMessage>, SenderIdList>>
      _revalidateSenderIds(
          {required GetAccountDetailsFormParams
              getAccountDetailsFormParams}) async {
    final _revalidateSenderIdsEither = await _repository.revalidateSenderIds(
        getAccountDetailsFormParams: getAccountDetailsFormParams);

    final _state = _revalidateSenderIdsEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, SenderIdList>.error(
          failure: failure),
      (senderIdList) {
        // cache snapshot
        _snapshotCache.senderIdList = senderIdList;

        return BlocState<Failure<ExceptionMessage>, SenderIdList>.success(
            data: senderIdList);
      },
    );

    return _state;
  }

  Future<void> getSenderIds(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    emit(const BlocState<Failure<ExceptionMessage>, SenderIdList>.loading());

    final _getSenderIdsEither = await _repository.getSenderIds(
        getAccountDetailsFormParams: getAccountDetailsFormParams);

    return _getSenderIdsEither.fold(
      (failure) async {
        final _state = await _revalidateSenderIds(
            getAccountDetailsFormParams: getAccountDetailsFormParams);

        emit(_state);
      },
      (senderIdList) async {
        // cache snapshot
        _snapshotCache.senderIdList = senderIdList;

        emit(BlocState<Failure<ExceptionMessage>, SenderIdList>.success(
            data: senderIdList));

        // revalidate sender-ids
        final _state = await _revalidateSenderIds(
            getAccountDetailsFormParams: getAccountDetailsFormParams);

        emit(_state);
      },
    );
  }
}
