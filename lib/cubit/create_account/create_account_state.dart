import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_account_state.freezed.dart';

@freezed
class CreateAccountState with _$CreateAccountState {
  const factory CreateAccountState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default('') String errorMessage,
  }) = _CreateAccountState;
}
