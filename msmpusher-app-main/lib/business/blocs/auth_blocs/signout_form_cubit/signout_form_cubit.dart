import 'package:bloc/bloc.dart';
import 'package:msmpusher/business/blocs/bloc_state.dart';
import 'package:msmpusher/core/exceptions/exceptions.dart';
import 'package:msmpusher/core/util/unit_impl.dart';
import 'package:msmpusher/domain/repositories/repositories.dart';

class SignoutFormCubit
    extends Cubit<BlocState<Failure<ExceptionMessage>, UnitImpl>> {
  final AuthRepository _repository;

  SignoutFormCubit({required AuthRepository repository})
      : _repository = repository,
        super(const BlocState<Failure<ExceptionMessage>, UnitImpl>.initial());

  Future<void> signout() async {
    emit(const BlocState<Failure<ExceptionMessage>, UnitImpl>.loading());

    final _signoutEither = await _repository.signout();

    final _state = _signoutEither.fold(
      (failure) => BlocState<Failure<ExceptionMessage>, UnitImpl>.error(
          failure: failure),
      (_) => BlocState<Failure<ExceptionMessage>, UnitImpl>.success(data: _),
    );

    emit(_state);
  }
}
