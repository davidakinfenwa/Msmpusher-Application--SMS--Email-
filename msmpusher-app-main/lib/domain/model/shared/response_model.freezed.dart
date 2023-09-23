// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ResponseModelTearOff {
  const _$ResponseModelTearOff();

  SuccessResponse<T> successResponse<T>({required T data}) {
    return SuccessResponse<T>(
      data: data,
    );
  }

  ErrorResponse<T> errorResponse<T>({required GenericResponseModel data}) {
    return ErrorResponse<T>(
      data: data,
    );
  }
}

/// @nodoc
const $ResponseModel = _$ResponseModelTearOff();

/// @nodoc
mixin _$ResponseModel<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) successResponse,
    required TResult Function(GenericResponseModel data) errorResponse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? successResponse,
    TResult Function(GenericResponseModel data)? errorResponse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? successResponse,
    TResult Function(GenericResponseModel data)? errorResponse,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuccessResponse<T> value) successResponse,
    required TResult Function(ErrorResponse<T> value) errorResponse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SuccessResponse<T> value)? successResponse,
    TResult Function(ErrorResponse<T> value)? errorResponse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuccessResponse<T> value)? successResponse,
    TResult Function(ErrorResponse<T> value)? errorResponse,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseModelCopyWith<T, $Res> {
  factory $ResponseModelCopyWith(
          ResponseModel<T> value, $Res Function(ResponseModel<T>) then) =
      _$ResponseModelCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ResponseModelCopyWithImpl<T, $Res>
    implements $ResponseModelCopyWith<T, $Res> {
  _$ResponseModelCopyWithImpl(this._value, this._then);

  final ResponseModel<T> _value;
  // ignore: unused_field
  final $Res Function(ResponseModel<T>) _then;
}

/// @nodoc
abstract class $SuccessResponseCopyWith<T, $Res> {
  factory $SuccessResponseCopyWith(
          SuccessResponse<T> value, $Res Function(SuccessResponse<T>) then) =
      _$SuccessResponseCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class _$SuccessResponseCopyWithImpl<T, $Res>
    extends _$ResponseModelCopyWithImpl<T, $Res>
    implements $SuccessResponseCopyWith<T, $Res> {
  _$SuccessResponseCopyWithImpl(
      SuccessResponse<T> _value, $Res Function(SuccessResponse<T>) _then)
      : super(_value, (v) => _then(v as SuccessResponse<T>));

  @override
  SuccessResponse<T> get _value => super._value as SuccessResponse<T>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(SuccessResponse<T>(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$SuccessResponse<T> implements SuccessResponse<T> {
  const _$SuccessResponse({required this.data});

  @override
  final T data;

  @override
  String toString() {
    return 'ResponseModel<$T>.successResponse(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SuccessResponse<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  $SuccessResponseCopyWith<T, SuccessResponse<T>> get copyWith =>
      _$SuccessResponseCopyWithImpl<T, SuccessResponse<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) successResponse,
    required TResult Function(GenericResponseModel data) errorResponse,
  }) {
    return successResponse(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? successResponse,
    TResult Function(GenericResponseModel data)? errorResponse,
  }) {
    return successResponse?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? successResponse,
    TResult Function(GenericResponseModel data)? errorResponse,
    required TResult orElse(),
  }) {
    if (successResponse != null) {
      return successResponse(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuccessResponse<T> value) successResponse,
    required TResult Function(ErrorResponse<T> value) errorResponse,
  }) {
    return successResponse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SuccessResponse<T> value)? successResponse,
    TResult Function(ErrorResponse<T> value)? errorResponse,
  }) {
    return successResponse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuccessResponse<T> value)? successResponse,
    TResult Function(ErrorResponse<T> value)? errorResponse,
    required TResult orElse(),
  }) {
    if (successResponse != null) {
      return successResponse(this);
    }
    return orElse();
  }
}

abstract class SuccessResponse<T> implements ResponseModel<T> {
  const factory SuccessResponse({required T data}) = _$SuccessResponse<T>;

  T get data;
  @JsonKey(ignore: true)
  $SuccessResponseCopyWith<T, SuccessResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorResponseCopyWith<T, $Res> {
  factory $ErrorResponseCopyWith(
          ErrorResponse<T> value, $Res Function(ErrorResponse<T>) then) =
      _$ErrorResponseCopyWithImpl<T, $Res>;
  $Res call({GenericResponseModel data});
}

/// @nodoc
class _$ErrorResponseCopyWithImpl<T, $Res>
    extends _$ResponseModelCopyWithImpl<T, $Res>
    implements $ErrorResponseCopyWith<T, $Res> {
  _$ErrorResponseCopyWithImpl(
      ErrorResponse<T> _value, $Res Function(ErrorResponse<T>) _then)
      : super(_value, (v) => _then(v as ErrorResponse<T>));

  @override
  ErrorResponse<T> get _value => super._value as ErrorResponse<T>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(ErrorResponse<T>(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GenericResponseModel,
    ));
  }
}

/// @nodoc

class _$ErrorResponse<T> implements ErrorResponse<T> {
  const _$ErrorResponse({required this.data});

  @override
  final GenericResponseModel data;

  @override
  String toString() {
    return 'ResponseModel<$T>.errorResponse(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ErrorResponse<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  $ErrorResponseCopyWith<T, ErrorResponse<T>> get copyWith =>
      _$ErrorResponseCopyWithImpl<T, ErrorResponse<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) successResponse,
    required TResult Function(GenericResponseModel data) errorResponse,
  }) {
    return errorResponse(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? successResponse,
    TResult Function(GenericResponseModel data)? errorResponse,
  }) {
    return errorResponse?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? successResponse,
    TResult Function(GenericResponseModel data)? errorResponse,
    required TResult orElse(),
  }) {
    if (errorResponse != null) {
      return errorResponse(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuccessResponse<T> value) successResponse,
    required TResult Function(ErrorResponse<T> value) errorResponse,
  }) {
    return errorResponse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SuccessResponse<T> value)? successResponse,
    TResult Function(ErrorResponse<T> value)? errorResponse,
  }) {
    return errorResponse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuccessResponse<T> value)? successResponse,
    TResult Function(ErrorResponse<T> value)? errorResponse,
    required TResult orElse(),
  }) {
    if (errorResponse != null) {
      return errorResponse(this);
    }
    return orElse();
  }
}

abstract class ErrorResponse<T> implements ResponseModel<T> {
  const factory ErrorResponse({required GenericResponseModel data}) =
      _$ErrorResponse<T>;

  GenericResponseModel get data;
  @JsonKey(ignore: true)
  $ErrorResponseCopyWith<T, ErrorResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
