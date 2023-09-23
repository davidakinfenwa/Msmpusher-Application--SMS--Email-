import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/domain/form_params/form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class GetAccountMetricsCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, AccountMetric>> {
  final AccountRepository _repository;
  final AccountDetailsSnapshotCache _snapshotCache;

  GetAccountMetricsCubit({
    required AccountRepository repository,
    required AccountDetailsSnapshotCache snapshotCache,
  })  : _repository = repository,
        _snapshotCache = snapshotCache,
        super(const BlocState<Failure<ExceptionMessage>,
            AccountMetric>.initial());

  Future<BlocState<Failure<ExceptionMessage>, AccountMetric>>
      _revalidateAccountMetric({
    required GetAccountDetailsFormParams getAccountDetailsFormParams,
  }) async {
    final _accountMetricEither = await _repository.revalidateAccountMetrics(
        getAccountDetailsFormParams: getAccountDetailsFormParams);

    final _state = _accountMetricEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, AccountMetric>.error(
          failure: failure),
      (accountMetric) {
        // cache snapshot
        final _updatedAccountMetrics = _snapshotCache.accountMetric
            .copyWith(accountSmsMetric: accountMetric.accountSmsMetric);

        // merge with already populated local-metrics (eg. contacts)
        _snapshotCache.accountMetric = _updatedAccountMetrics;

        return BlocState<Failure<ExceptionMessage>, AccountMetric>.success(
            data: accountMetric);
      },
    );

    return _state;
  }

  Future<void> getAccountMetrics({
    required GetAccountDetailsFormParams getAccountDetailsFormParams,
  }) async {
    emit(const BlocState<Failure<ExceptionMessage>, AccountMetric>.loading());

    final _accountMetricEither = await _repository.getAccountMetrics(
        getAccountDetailsFormParams: getAccountDetailsFormParams);

    return _accountMetricEither.fold(
      (failure) async {
        final _state = await _revalidateAccountMetric(
            getAccountDetailsFormParams: getAccountDetailsFormParams);

        emit(_state);
      },
      (accountMetric) async {
        // cache snapshot
        _snapshotCache.accountMetric = accountMetric;

        emit(BlocState<Failure<ExceptionMessage>, AccountMetric>.success(
            data: accountMetric));

        // emit loading-state for revalidate-account-metrics usecase
        emit(const BlocState<Failure<ExceptionMessage>,
            AccountMetric>.loading());

        final _state = await _revalidateAccountMetric(
            getAccountDetailsFormParams: getAccountDetailsFormParams);

        emit(_state);
      },
    );
  }
}
