import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default('') String errorMessage,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String email,
    @Default('') String dateOfBirth,
    @Default('') String imageUrl,
  }) = _ProfileState;
}
