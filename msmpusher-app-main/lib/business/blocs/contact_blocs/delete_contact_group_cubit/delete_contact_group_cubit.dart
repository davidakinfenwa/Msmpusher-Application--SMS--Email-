import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class DeleteContactGroupCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, UnitImpl>> {
  final ContactRepository _repository;
  final GroupSnapshotCache _snapshotCache;

  DeleteContactGroupCubit({
    required ContactRepository repository,
    required GroupSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>, UnitImpl>.initial());

  Future<void> deleteContactGroup({required UniqueId uniqueId}) async {
    emit(const BlocState<Failure<ExceptionMessage>, UnitImpl>.loading());

    final _deleteContactGroupEither =
        await _repository.deleteGroup(uniqueId: uniqueId);

    final _state = _deleteContactGroupEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, UnitImpl>.error(
          failure: failure),
      (_) {
        // get all groups
        final _groups = _snapshotCache.contactGroupList.groups;

        // delete group from group-list
        _groups.removeWhere(
            (element) => element.uniqueId.toString() == uniqueId.toString());

        // set updated contact-group-list
        _snapshotCache.contactGroupList = ContactGroupList(groups: _groups);

        return BlocState<Failure<ExceptionMessage>, UnitImpl>.success(data: _);
      },
    );

    emit(_state);
  }
}
