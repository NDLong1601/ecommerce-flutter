// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateAccountState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of CreateAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateAccountStateCopyWith<CreateAccountState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateAccountStateCopyWith<$Res> {
  factory $CreateAccountStateCopyWith(
    CreateAccountState value,
    $Res Function(CreateAccountState) then,
  ) = _$CreateAccountStateCopyWithImpl<$Res, CreateAccountState>;
  @useResult
  $Res call({bool isLoading, bool isSuccess, String errorMessage});
}

/// @nodoc
class _$CreateAccountStateCopyWithImpl<$Res, $Val extends CreateAccountState>
    implements $CreateAccountStateCopyWith<$Res> {
  _$CreateAccountStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorMessage = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: null == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateAccountStateImplCopyWith<$Res>
    implements $CreateAccountStateCopyWith<$Res> {
  factory _$$CreateAccountStateImplCopyWith(
    _$CreateAccountStateImpl value,
    $Res Function(_$CreateAccountStateImpl) then,
  ) = __$$CreateAccountStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, bool isSuccess, String errorMessage});
}

/// @nodoc
class __$$CreateAccountStateImplCopyWithImpl<$Res>
    extends _$CreateAccountStateCopyWithImpl<$Res, _$CreateAccountStateImpl>
    implements _$$CreateAccountStateImplCopyWith<$Res> {
  __$$CreateAccountStateImplCopyWithImpl(
    _$CreateAccountStateImpl _value,
    $Res Function(_$CreateAccountStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorMessage = null,
  }) {
    return _then(
      _$CreateAccountStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CreateAccountStateImpl implements _CreateAccountState {
  const _$CreateAccountStateImpl({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'CreateAccountState(isLoading: $isLoading, isSuccess: $isSuccess, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateAccountStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, isSuccess, errorMessage);

  /// Create a copy of CreateAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateAccountStateImplCopyWith<_$CreateAccountStateImpl> get copyWith =>
      __$$CreateAccountStateImplCopyWithImpl<_$CreateAccountStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateAccountState implements CreateAccountState {
  const factory _CreateAccountState({
    final bool isLoading,
    final bool isSuccess,
    final String errorMessage,
  }) = _$CreateAccountStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  String get errorMessage;

  /// Create a copy of CreateAccountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateAccountStateImplCopyWith<_$CreateAccountStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
