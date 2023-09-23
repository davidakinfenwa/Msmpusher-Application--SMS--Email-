import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class DeleteSenderIdCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, SenderIdList>> {
  final SenderRepository _repository;
  final SenderSnapshotCache _snapshotCache;

  DeleteSenderIdCubit({
    required SenderRepository repository,
    required SenderSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(
            const BlocState<Failure<ExceptionMessage>, SenderIdList>.initial());

  Future<void> deleteSenderId(
      {required DeleteSenderIdFormParams deleteSenderIdFormParams}) async {
    emit(const BlocState<Failure<ExceptionMessage>, SenderIdList>.loading());

    final _deleteSenderIdEither = await _repository.deleteSenderId(
        deleteSenderIdFormParams: deleteSenderIdFormParams);

    final _state = _deleteSenderIdEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, SenderIdList>.error(
          failure: failure),
      (senderIdList) {
        // cache snapshot
        _snapshotCache.senderIdList = senderIdList;

        return BlocState<Failure<ExceptionMessage>, SenderIdList>.success(
            data: senderIdList);
      },
    );

    emit(_state);
  }
}
