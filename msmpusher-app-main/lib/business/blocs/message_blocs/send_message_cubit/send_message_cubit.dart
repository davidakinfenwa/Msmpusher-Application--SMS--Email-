import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class SendMessageCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, MessageInfoList>> {
  final MessageRepository _repository;
  final MessageSnapshotCache _snapshotCache;

  SendMessageCubit({
    required MessageRepository repository,
    required MessageSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            MessageInfoList>.initial());

  Future<void> sendMessage(
      {required SendMessageFormParams sendMessageFormParams}) async {
    emit(const BlocState<Failure<ExceptionMessage>, MessageInfoList>.loading());

    final _sendMessageEither = await _repository.sendMessage(
        sendMessageFormParams: sendMessageFormParams);

    final _state = _sendMessageEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, MessageInfoList>.error(
          failure: failure),
      (messageInfoList) {
        // cache snapshot
        _snapshotCache.messageInfoList = messageInfoList;

        return BlocState<Failure<ExceptionMessage>, MessageInfoList>.success(
            data: messageInfoList);
      },
    );

    emit(_state);
  }
}
