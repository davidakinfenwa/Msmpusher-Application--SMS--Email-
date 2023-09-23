import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class GetAccountBalanceCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, AccountBalance>> {
  final AccountRepository _repository;
  final AccountDetailsSnapshotCache _snapshotCache;

  GetAccountBalanceCubit({
    required AccountRepository repository,
    required AccountDetailsSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            AccountBalance>.initial());

  Future<BlocState<Failure<ExceptionMessage>, AccountBalance>>
      _revalidateAccountBalance({
    required GetAccountDetailsFormParams getAccountDetailsFormParams,
  }) async {
    final _accountBalanceEither = await _repository.revalidateAccountBalance(
        getAccountDetailsFormParams: getAccountDetailsFormParams);

    final _state = _accountBalanceEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, AccountBalance>.error(
          failure: failure),
      (accountBalance) {
        // cache snapshot
        _snapshotCache.accountBalance = accountBalance;

        return BlocState<Failure<ExceptionMessage>, AccountBalance>.success(
            data: accountBalance);
      },
    );

    return _state;
  }

  Future<void> getAccountBalance(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    emit(const BlocState<Failure<ExceptionMessage>, AccountBalance>.loading());

    final _accountBalanceEither = await _repository.getAccountBalance(
        getAccountDetailsFormParams: getAccountDetailsFormParams);

    return _accountBalanceEither.fold(
      (failure) async {
        final _state = await _revalidateAccountBalance(
            getAccountDetailsFormParams: getAccountDetailsFormParams);

        emit(_state);
      },
      (accountBalance) async {
        // cache snapshot
        _snapshotCache.accountBalance = accountBalance;

        emit(BlocState<Failure<ExceptionMessage>, AccountBalance>.success(
            data: accountBalance));

        // emit loading-state for revalidate-account-balance usecase
        emit(const BlocState<Failure<ExceptionMessage>,
            AccountBalance>.loading());

        final _state = await _revalidateAccountBalance(
            getAccountDetailsFormParams: getAccountDetailsFormParams);

        emit(_state);
      },
    );
  }
}
