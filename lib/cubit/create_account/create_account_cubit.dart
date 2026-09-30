import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_mobile_app/services/remote/remote.dart';
import 'create_account_state.dart';

@injectable
class CreateAccountCubit extends Cubit<CreateAccountState> {
  final FirebaseService _firebaseService;

  CreateAccountCubit(this._firebaseService) : super(const CreateAccountState());

  Future<void> createAccountWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: ''));

    try {
      await _firebaseService.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
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
    emit(const CreateAccountState());
  }
}
