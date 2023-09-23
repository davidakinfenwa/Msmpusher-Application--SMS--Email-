import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class GetMessageReportsCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, MessageInfoList>> {
  final MessageRepository _repository;
  final MessageSnapshotCache _snapshotCache;

  GetMessageReportsCubit({
    required MessageRepository repository,
    required MessageSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            MessageInfoList>.initial());

  Future<BlocState<Failure<ExceptionMessage>, MessageInfoList>>
      _revalidateMessageInfoList({
    required GetMessageReportsFormParams getMessageReportsFormParams,
  }) async {
    final _revalidateMessageInfoListEither =
        await _repository.revalidateMessageReports(
            getMessageReportsFormParams: getMessageReportsFormParams);

    final _state = _revalidateMessageInfoListEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, MessageInfoList>.error(
          failure: failure),
      (messageInfoList) {
        // cache snapshot
        _snapshotCache.messageInfoList = messageInfoList;

        return BlocState<Failure<ExceptionMessage>, MessageInfoList>.success(
            data: messageInfoList);
      },
    );

    return _state;
  }

  Future<void> getMessageInfoList({
    required GetMessageReportsFormParams getMessageReportsFormParams,
  }) async {
    emit(const BlocState<Failure<ExceptionMessage>, MessageInfoList>.loading());

    final _getMessageInfoListEither = await _repository.getMessageReports(
        getMessageReportsFormParams: getMessageReportsFormParams);

    return _getMessageInfoListEither.fold(
      (failure) async {
        final _state = await _revalidateMessageInfoList(
            getMessageReportsFormParams: getMessageReportsFormParams);

        emit(_state);
      },
      (messageInfoList) async {
        // cache snapshot
        _snapshotCache.messageInfoList = messageInfoList;

        emit(BlocState<Failure<ExceptionMessage>, MessageInfoList>.success(
            data: messageInfoList));

        // revalidate message-info-list
        final _state = await _revalidateMessageInfoList(
            getMessageReportsFormParams: getMessageReportsFormParams);

        emit(_state);
      },
    );
  }
}
