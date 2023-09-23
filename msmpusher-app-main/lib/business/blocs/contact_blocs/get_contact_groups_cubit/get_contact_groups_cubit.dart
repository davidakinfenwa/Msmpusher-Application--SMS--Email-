import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class GetContactGroupsCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, ContactGroupList>> {
  final ContactRepository _repository;
  final GroupSnapshotCache _snapshotCache;

  GetContactGroupsCubit({
    required ContactRepository repository,
    required GroupSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            ContactGroupList>.initial());

  Future<void> getContactGroups() async {
    emit(
        const BlocState<Failure<ExceptionMessage>, ContactGroupList>.loading());

    final _getContactGroupEither = await _repository.getGroups();

    final _state = _getContactGroupEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, ContactGroupList>.error(
          failure: failure),
      (contactGroupList) {
        // cache snapshot
        _snapshotCache.contactGroupList = contactGroupList;

        return BlocState<Failure<ExceptionMessage>, ContactGroupList>.success(
            data: contactGroupList);
      },
    );

    emit(_state);
  }
}
