import 'package:ecommerce_mobile_app/services/remote/remote.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final FirebaseService _firebaseService;

  SignInCubit(this._firebaseService) : super(const SignInState());

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: ''));

    try {
      await _firebaseService.signInWithEmail(email: email, password: password);
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
    emit(const SignInState());
  }
}
