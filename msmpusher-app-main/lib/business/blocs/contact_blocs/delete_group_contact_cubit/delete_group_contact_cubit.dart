import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class DeleteGroupContactCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, ContactGroup>> {
  final ContactRepository _repository;
  final GroupSnapshotCache _snapshotCache;

  DeleteGroupContactCubit({
    required ContactRepository repository,
    required GroupSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(
            const BlocState<Failure<ExceptionMessage>, ContactGroup>.initial());

  Future<void> deleteGroupContact({
    required UniqueId groupUniqueId,
    required UniqueId contactUniqueId,
  }) async {
    emit(const BlocState<Failure<ExceptionMessage>, ContactGroup>.loading());

    final _deleteGroupContactEither = await _repository.deleteGroupContact(
        groupUniqueId: groupUniqueId, contactUniqueId: contactUniqueId);

    final _state = _deleteGroupContactEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, ContactGroup>.error(
          failure: failure),
      (contactGroup) {
        // get all groups
        final _groups = _snapshotCache.contactGroupList.groups;

        // find and replace contact-group with modified contact-group
        final _contactGroupIndex = _groups.indexWhere((element) =>
            element.uniqueId.toString() == groupUniqueId.toString());

        // set updated contact-group-list
        _groups[_contactGroupIndex] = contactGroup;
        _snapshotCache.contactGroupList = ContactGroupList(groups: _groups);

        return BlocState<Failure<ExceptionMessage>, ContactGroup>.success(
            data: contactGroup);
      },
    );

    emit(_state);
  }
}
