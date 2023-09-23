import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class GetDeviceFileContactsCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, ContactModelList>> {
  final ContactRepository _repository;
  final ContactSnapshotCache _snapshotCache;

  GetDeviceFileContactsCubit({
    required ContactRepository repository,
    required ContactSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            ContactModelList>.initial());

  Future<void> getDeviceFileContacts() async {
    emit(
        const BlocState<Failure<ExceptionMessage>, ContactModelList>.loading());

    final _eitherFailureOrContactModelList =
        await _repository.getContactsFromFile();

    final _state = _eitherFailureOrContactModelList.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, ContactModelList>.error(
        failure: failure,
      ),
      (contactModelList) {
        // cache snapshot
        _snapshotCache.deviceFileContacts = contactModelList;

        return BlocState<Failure<ExceptionMessage>, ContactModelList>.success(
          data: contactModelList,
        );
      },
    );

    emit(_state);
  }
}
