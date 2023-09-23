import 'package:dartz/dartz.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/network/network.dart';
import 'package:msmpusher/data/datasources/datasources.dart';
import 'package:msmpusher/domain/form_params/message/get_message_reports_form_params.dart';
import 'package:msmpusher/domain/form_params/message/send_message_form_params.dart';
import 'package:msmpusher/domain/model/models.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class MessageRepositoryImpl implements MessageRepository {
  final NetworkInfo _networkInfo;
  final MessageLocalDataSource _localDataSource;
  final MessageRemoteDataSource _remoteDataSource;

  MessageRepositoryImpl({
    required NetworkInfo networkInfo,
    required MessageLocalDataSource localDataSource,
    required MessageRemoteDataSource remoteDataSource,
  })  : _networkInfo = networkInfo,
        _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  Future<Either<Failure<ExceptionMessage>, MessageInfoList>>
      _getMessageInfoListFromLocalDataSource(
          {required GetMessageReportsFormParams
              getMessageReportsFormParams}) async {
    try {
      final _messageInfoList = await _localDataSource.getMessageInfos(
          getMessageReportsFormParams: getMessageReportsFormParams);

      return right(_messageInfoList);
    } on ExceptionType<ExceptionMessage> catch (e) {
      return left(Failure.cacheFailure(exception: e));
    }
  }

  Future<MessageInfoList> _cacheCreatedMessageInfoToLocalDataSource({
    required SuccessResponse<MessageInfoList> state,
    required SendMessageFormParams sendMessageFormParams,
  }) async {
    final _getMessageReportsFormParams = GetMessageReportsFormParams(
      userInfo: sendMessageFormParams.userInfo,
    );

    // get cached message-info list
    final _messageInfoListEither = await _getMessageInfoListFromLocalDataSource(
        getMessageReportsFormParams: _getMessageReportsFormParams);

    List<MessageInfo> _messageInfos = <MessageInfo>[];

    if (_messageInfoListEither.isLeft()) {
      _messageInfos = [...state.data.messages];
    } else {
      final _messageInfoListFromCache =
          _messageInfoListEither.getOrElse(() => MessageInfoList.empty());

      // merge sent-message-info to cache message-info list
      _messageInfos = [
        ...state.data.messages,
        ..._messageInfoListFromCache.messages,
      ];
    }

    final _messageInfoList = MessageInfoList(messages: _messageInfos);

    await _localDataSource.cacheMessageInfos(
      messageInfoList: _messageInfoList,
      getMessageReportsFormParams: _getMessageReportsFormParams,
    );

    return _messageInfoList;
  }

  @override
  Future<Either<Failure<ExceptionMessage>, MessageInfoList>> getMessageReports(
          {required GetMessageReportsFormParams getMessageReportsFormParams}) =>
      _getMessageInfoListFromLocalDataSource(
          getMessageReportsFormParams: getMessageReportsFormParams);

  @override
  Future<Either<Failure<ExceptionMessage>, MessageInfoList>>
      revalidateMessageReports({
    required GetMessageReportsFormParams getMessageReportsFormParams,
  }) async {
    if (await _networkInfo.isConnected) {
      final _responseModel = await _remoteDataSource.getMessageReports(
          getMessageReportsFormParams: getMessageReportsFormParams);

      return _responseModel.map(
        errorResponse: (state) {
          final _exception = ExceptionType<ExceptionMessage>.serverException(
            code: ExceptionCode.UNDEFINED,
            message: ExceptionMessage.parse(state.data.message),
          );

          return left(Failure.serverFailure(exception: _exception));
        },
        successResponse: (state) async {
          // cache data
          await _localDataSource.cacheMessageInfos(
            messageInfoList: state.data,
            getMessageReportsFormParams: getMessageReportsFormParams,
          );

          return right(state.data);
        },
      );
    }

    return left(const Failure.serverFailure(
        exception: ExceptionMessages.NO_INTERNET_CONNECTION));
  }

  @override
  Future<Either<Failure<ExceptionMessage>, MessageInfoList>> sendMessage(
      {required SendMessageFormParams sendMessageFormParams}) async {
    if (await _networkInfo.isConnected) {
      try {
        final _responseModel = await _remoteDataSource.sendMessage(
            sendMessageFormParams: sendMessageFormParams);

        return _responseModel.map(
          errorResponse: (state) {
            final _exception = ExceptionType<ExceptionMessage>.serverException(
              code: ExceptionCode.UNDEFINED,
              message: ExceptionMessage.parse(state.data.message),
            );

            return left(Failure.serverFailure(exception: _exception));
          },
          successResponse: (state) async {
            final _messageInfoList =
                await _cacheCreatedMessageInfoToLocalDataSource(
                    state: state, sendMessageFormParams: sendMessageFormParams);

            return right(_messageInfoList);
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
