import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_mobile_app/services/remote/remote.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseService _firebaseService;

  ProfileCubit(this._firebaseService) : super(const ProfileState());

  Future<void> loadUserProfile() async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        // Get user info from Firestore
        final userInfo = await _firebaseService.getUserInfo(user.uid);

        if (userInfo != null) {
          // Format date of birth for display
          final dateOfBirth = _formatDate(userInfo.dateOfBirth);

          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              firstName: userInfo.firstName,
              lastName: userInfo.lastName,
              email: userInfo.email,
              dateOfBirth: dateOfBirth,
              imageUrl: userInfo.avatarUrl,
            ),
          );
        } else {
          // User exists but no Firestore data
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              email: user.email ?? '',
              errorMessage: 'User profile not found',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'No user logged in',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    String? imageUrl,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        // Update user info in Firestore
        await _firebaseService.updateUserInfo(
          userId: user.uid,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          avatarUrl: imageUrl,
        );

        // Update local state
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            imageUrl: imageUrl ?? state.imageUrl,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'No user logged in',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _firebaseService.signOut();
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void resetState() {
    emit(const ProfileState());
  }
}
