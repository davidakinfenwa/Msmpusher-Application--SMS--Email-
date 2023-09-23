// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'message_recipient_list_union.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MessageRecipientListUnionTearOff {
  const _$MessageRecipientListUnionTearOff();

  _ContactModel contactModel({required ContactModelList contactModelList}) {
    return _ContactModel(
      contactModelList: contactModelList,
    );
  }

  _GroupModel groupModel({required ContactGroupList contactGroupList}) {
    return _GroupModel(
      contactGroupList: contactGroupList,
    );
  }
}

/// @nodoc
const $MessageRecipientListUnion = _$MessageRecipientListUnionTearOff();

/// @nodoc
mixin _$MessageRecipientListUnion {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ContactModelList contactModelList) contactModel,
    required TResult Function(ContactGroupList contactGroupList) groupModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ContactModelList contactModelList)? contactModel,
    TResult Function(ContactGroupList contactGroupList)? groupModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ContactModelList contactModelList)? contactModel,
    TResult Function(ContactGroupList contactGroupList)? groupModel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContactModel value) contactModel,
    required TResult Function(_GroupModel value) groupModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ContactModel value)? contactModel,
    TResult Function(_GroupModel value)? groupModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContactModel value)? contactModel,
    TResult Function(_GroupModel value)? groupModel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageRecipientListUnionCopyWith<$Res> {
  factory $MessageRecipientListUnionCopyWith(MessageRecipientListUnion value,
          $Res Function(MessageRecipientListUnion) then) =
      _$MessageRecipientListUnionCopyWithImpl<$Res>;
}

/// @nodoc
class _$MessageRecipientListUnionCopyWithImpl<$Res>
    implements $MessageRecipientListUnionCopyWith<$Res> {
  _$MessageRecipientListUnionCopyWithImpl(this._value, this._then);

  final MessageRecipientListUnion _value;
  // ignore: unused_field
  final $Res Function(MessageRecipientListUnion) _then;
}

/// @nodoc
abstract class _$ContactModelCopyWith<$Res> {
  factory _$ContactModelCopyWith(
          _ContactModel value, $Res Function(_ContactModel) then) =
      __$ContactModelCopyWithImpl<$Res>;
  $Res call({ContactModelList contactModelList});
}

/// @nodoc
class __$ContactModelCopyWithImpl<$Res>
    extends _$MessageRecipientListUnionCopyWithImpl<$Res>
    implements _$ContactModelCopyWith<$Res> {
  __$ContactModelCopyWithImpl(
      _ContactModel _value, $Res Function(_ContactModel) _then)
      : super(_value, (v) => _then(v as _ContactModel));

  @override
  _ContactModel get _value => super._value as _ContactModel;

  @override
  $Res call({
    Object? contactModelList = freezed,
  }) {
    return _then(_ContactModel(
      contactModelList: contactModelList == freezed
          ? _value.contactModelList
          : contactModelList // ignore: cast_nullable_to_non_nullable
              as ContactModelList,
    ));
  }
}

/// @nodoc

class _$_ContactModel implements _ContactModel {
  const _$_ContactModel({required this.contactModelList});

  @override
  final ContactModelList contactModelList;

  @override
  String toString() {
    return 'MessageRecipientListUnion.contactModel(contactModelList: $contactModelList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ContactModel &&
            const DeepCollectionEquality()
                .equals(other.contactModelList, contactModelList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(contactModelList));

  @JsonKey(ignore: true)
  @override
  _$ContactModelCopyWith<_ContactModel> get copyWith =>
      __$ContactModelCopyWithImpl<_ContactModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ContactModelList contactModelList) contactModel,
    required TResult Function(ContactGroupList contactGroupList) groupModel,
  }) {
    return contactModel(contactModelList);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ContactModelList contactModelList)? contactModel,
    TResult Function(ContactGroupList contactGroupList)? groupModel,
  }) {
    return contactModel?.call(contactModelList);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ContactModelList contactModelList)? contactModel,
    TResult Function(ContactGroupList contactGroupList)? groupModel,
    required TResult orElse(),
  }) {
    if (contactModel != null) {
      return contactModel(contactModelList);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContactModel value) contactModel,
    required TResult Function(_GroupModel value) groupModel,
  }) {
    return contactModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ContactModel value)? contactModel,
    TResult Function(_GroupModel value)? groupModel,
  }) {
    return contactModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContactModel value)? contactModel,
    TResult Function(_GroupModel value)? groupModel,
    required TResult orElse(),
  }) {
    if (contactModel != null) {
      return contactModel(this);
    }
    return orElse();
  }
}

abstract class _ContactModel implements MessageRecipientListUnion {
  const factory _ContactModel({required ContactModelList contactModelList}) =
      _$_ContactModel;

  ContactModelList get contactModelList;
  @JsonKey(ignore: true)
  _$ContactModelCopyWith<_ContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$GroupModelCopyWith<$Res> {
  factory _$GroupModelCopyWith(
          _GroupModel value, $Res Function(_GroupModel) then) =
      __$GroupModelCopyWithImpl<$Res>;
  $Res call({ContactGroupList contactGroupList});
}

/// @nodoc
class __$GroupModelCopyWithImpl<$Res>
    extends _$MessageRecipientListUnionCopyWithImpl<$Res>
    implements _$GroupModelCopyWith<$Res> {
  __$GroupModelCopyWithImpl(
      _GroupModel _value, $Res Function(_GroupModel) _then)
      : super(_value, (v) => _then(v as _GroupModel));

  @override
  _GroupModel get _value => super._value as _GroupModel;

  @override
  $Res call({
    Object? contactGroupList = freezed,
  }) {
    return _then(_GroupModel(
      contactGroupList: contactGroupList == freezed
          ? _value.contactGroupList
          : contactGroupList // ignore: cast_nullable_to_non_nullable
              as ContactGroupList,
    ));
  }
}

/// @nodoc

class _$_GroupModel implements _GroupModel {
  const _$_GroupModel({required this.contactGroupList});

  @override
  final ContactGroupList contactGroupList;

  @override
  String toString() {
    return 'MessageRecipientListUnion.groupModel(contactGroupList: $contactGroupList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupModel &&
            const DeepCollectionEquality()
                .equals(other.contactGroupList, contactGroupList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(contactGroupList));

  @JsonKey(ignore: true)
  @override
  _$GroupModelCopyWith<_GroupModel> get copyWith =>
      __$GroupModelCopyWithImpl<_GroupModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ContactModelList contactModelList) contactModel,
    required TResult Function(ContactGroupList contactGroupList) groupModel,
  }) {
    return groupModel(contactGroupList);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ContactModelList contactModelList)? contactModel,
    TResult Function(ContactGroupList contactGroupList)? groupModel,
  }) {
    return groupModel?.call(contactGroupList);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ContactModelList contactModelList)? contactModel,
    TResult Function(ContactGroupList contactGroupList)? groupModel,
    required TResult orElse(),
  }) {
    if (groupModel != null) {
      return groupModel(contactGroupList);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ContactModel value) contactModel,
    required TResult Function(_GroupModel value) groupModel,
  }) {
    return groupModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ContactModel value)? contactModel,
    TResult Function(_GroupModel value)? groupModel,
  }) {
    return groupModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ContactModel value)? contactModel,
    TResult Function(_GroupModel value)? groupModel,
    required TResult orElse(),
  }) {
    if (groupModel != null) {
      return groupModel(this);
    }
    return orElse();
  }
}

abstract class _GroupModel implements MessageRecipientListUnion {
  const factory _GroupModel({required ContactGroupList contactGroupList}) =
      _$_GroupModel;

  ContactGroupList get contactGroupList;
  @JsonKey(ignore: true)
  _$GroupModelCopyWith<_GroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}
