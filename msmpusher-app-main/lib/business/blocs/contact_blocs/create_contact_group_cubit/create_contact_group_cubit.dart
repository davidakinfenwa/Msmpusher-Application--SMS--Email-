import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class CreateContactGroupCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, ContactGroup>> {
  final ContactRepository _repository;
  final GroupSnapshotCache _snapshotCache;

  CreateContactGroupCubit({
    required ContactRepository repository,
    required GroupSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(
            const BlocState<Failure<ExceptionMessage>, ContactGroup>.initial());

  Future<void> createContactGroup({required ContactGroup contactGroup}) async {
    emit(const BlocState<Failure<ExceptionMessage>, ContactGroup>.loading());

    final _createContactGroupEither =
        await _repository.createGroup(contactGroup: contactGroup);

    final _state = _createContactGroupEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, ContactGroup>.error(
          failure: failure),
      (_) {
        // add created group to group-list
        final _addedContactGroupList = [
          contactGroup,
          ..._snapshotCache.contactGroupList.groups,
        ];

        // set updated contact-group-list
        _snapshotCache.contactGroupList =
            ContactGroupList(groups: _addedContactGroupList);

        return BlocState<Failure<ExceptionMessage>, ContactGroup>.success(
            data: contactGroup);
      },
    );

    emit(_state);
  }
}
