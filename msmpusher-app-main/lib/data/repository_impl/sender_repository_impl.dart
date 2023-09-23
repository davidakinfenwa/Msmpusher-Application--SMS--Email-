import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/domain/form_params/account/get_account_details_form_params.dart';
import 'package:msmpusher/domain/form_params/sender/create_sender_id_form_params.dart';
import 'package:msmpusher/domain/form_params/sender/delete_sender_id_form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class SenderRepositoryImpl implements SenderRepository {
  final NetworkInfo _networkInfo;
  final SenderLocalDataSource _localDataSource;
  final SenderRemoteDataSource _remoteDataSource;

  SenderRepositoryImpl({
    required NetworkInfo networkInfo,
    required SenderLocalDataSource localDataSource,
    required SenderRemoteDataSource remoteDataSource,
  })  : _networkInfo = networkInfo,
        _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  Future<Either<Failure<ExceptionMessage>, SenderIdList>>
      _getSenderIdFromLocalDataSource(
          GetAccountDetailsFormParams getAccountDetailsFormParams) async {
    try {
      final _senderIdList =
          await _localDataSource.getSenderIds(getAccountDetailsFormParams);

      return right(_senderIdList);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.cacheFailure(exception: e));
    }
  }

  Future<SenderIdList> _cacheCreatedSenderIdInLocalDataSource({
    required SenderIdList senderIdList,
    required CreateSenderIdFormParams createSenderIdFormParams,
  }) async {
    final _getAccountDetailsFormParams = GetAccountDetailsFormParams(
      userId: createSenderIdFormParams.userId,
      accountNumber: createSenderIdFormParams.accountNumber,
    );

    // get sender-id list from local-data source
    final _senderIdListEither =
        await _getSenderIdFromLocalDataSource(_getAccountDetailsFormParams);

    List<SenderId> _senderIds = <SenderId>[];

    if (_senderIdListEither.isLeft()) {
      _senderIds = [...senderIdList.senderIds];
    } else {
      final _senderIdListFromCache =
          _senderIdListEither.getOrElse(() => SenderIdList.empty());

      // merge created-sender-id to cache sender-id list
      _senderIds = [
        ...senderIdList.senderIds,
        ..._senderIdListFromCache.senderIds
      ];
    }

    final _senderIdList = SenderIdList(senderIds: _senderIds);

    await _localDataSource.cacheSenderIds(
      senderIdList: _senderIdList,
      getAccountDetailsFormParams: _getAccountDetailsFormParams,
    );

    return _senderIdList;
  }

  Future<SenderIdList> _deleteSenderIdFromLocalDataSource({
    required DeleteSenderIdFormParams deleteSenderIdFormParams,
  }) async {
    final _getAccountDetailsFormParams = GetAccountDetailsFormParams(
      userId: deleteSenderIdFormParams.userId,
      accountNumber: deleteSenderIdFormParams.accountNumber,
    );

    // get sender-id list from local-data source
    final _senderIdListEither =
        await _getSenderIdFromLocalDataSource(_getAccountDetailsFormParams);

    if (_senderIdListEither.isRight()) {
      final _senderIdListFromCache =
          _senderIdListEither.getOrElse(() => SenderIdList.empty());

      // spread sender-id list
      final _senderIds = [..._senderIdListFromCache.senderIds];

      // delete match from list
      _senderIds.removeWhere(
          (element) => element.sId == deleteSenderIdFormParams.sid);

      // cache updated sender-id list
      final _senderIdList = SenderIdList(senderIds: _senderIds);

      await _localDataSource.cacheSenderIds(
        senderIdList: _senderIdList,
        getAccountDetailsFormParams: _getAccountDetailsFormParams,
      );

      return _senderIdList;
    }

    return SenderIdList.empty();
  }

  @override
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> getSenderIds(
          {required GetAccountDetailsFormParams getAccountDetailsFormParams}) =>
      _getSenderIdFromLocalDataSource(getAccountDetailsFormParams);

  @override
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> revalidateSenderIds(
      {required GetAccountDetailsFormParams
          getAccountDetailsFormParams}) async {
    if (await _networkInfo.isConnected) {
      try {
        final _responseModel = await _remoteDataSource.getSenderIds(
            getAccountDetailsFormParams: getAccountDetailsFormParams);

        return _responseModel.map(
          errorResponse: (state) {
            final _exception = ExceptionType<ExceptionMessage>.serverException(
              code: ExceptionCode.UNDEFINED,
              message: ExceptionMessage.parse(state.data.message),
            );

            return left(Failure.serverFailure(exception: _exception));
          },
          successResponse: (state) async {
            // cache result
            await _localDataSource.cacheSenderIds(
              senderIdList: state.data,
              getAccountDetailsFormParams: getAccountDetailsFormParams,
            );

            return right(state.data);
          },
        );
      } on ExceptionType<ExceptionMessage> catch (e) {
        return left(Failure.serverFailure(exception: e));
      }
    }

    return left(const Failure.serverFailure(
        exception: ExceptionMessages.NO_INTERNET_CONNECTION));
  }

  @override
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> createSenderId(
      {required CreateSenderIdFormParams createSenderIdFormParams}) async {
    if (await _networkInfo.isConnected) {
      try {
        final _responseModel = await _remoteDataSource.createSenderId(
            createSenderIdFormParams: createSenderIdFormParams);

        return _responseModel.map(
          errorResponse: (state) {
            final _exception = ExceptionType<ExceptionMessage>.serverException(
              code: ExceptionCode.UNDEFINED,
              message: ExceptionMessage.parse(state.data.message),
            );

            return left(Failure.serverFailure(exception: _exception));
          },
          successResponse: (state) async {
            // cache response
            final _senderIdList = await _cacheCreatedSenderIdInLocalDataSource(
              senderIdList: state.data,
              createSenderIdFormParams: createSenderIdFormParams,
            );

            return right(_senderIdList);
          },
        );
      } on ExceptionType<ExceptionMessage> catch (e) {
        return left(Failure.serverFailure(exception: e));
      }
    }

    return left(const Failure.serverFailure(
        exception: ExceptionMessages.NO_INTERNET_CONNECTION));
  }

  @override
  Future<Either<Failure<ExceptionMessage>, SenderIdList>> deleteSenderId(
      {required DeleteSenderIdFormParams deleteSenderIdFormParams}) async {
    if (await _networkInfo.isConnected) {
      try {
        final _responseModel = await _remoteDataSource.deleteSenderId(
            deleteSenderIdFormParams: deleteSenderIdFormParams);

        return _responseModel.map(
          errorResponse: (state) {
            final _exception = ExceptionType<ExceptionMessage>.serverException(
              code: ExceptionCode.UNDEFINED,
              message: ExceptionMessage.parse(state.data.message),
            );

            return left(Failure.serverFailure(exception: _exception));
          },
          successResponse: (state) async {
            // cache result
            final _senderIdList = await _deleteSenderIdFromLocalDataSource(
                deleteSenderIdFormParams: deleteSenderIdFormParams);

            return right(_senderIdList);
          },
        );
      } on ExceptionType<ExceptionMessage> catch (e) {
        return left(Failure.serverFailure(exception: e));
      }
    }

    return left(const Failure.serverFailure(
        exception: ExceptionMessages.NO_INTERNET_CONNECTION));
  }
}
