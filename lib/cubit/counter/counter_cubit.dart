import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'counter_state.dart';

@injectable
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());

  void increment() {
    emit(state.copyWith(count: state.count + 1));
  }

  void decrement() {
    emit(state.copyWith(count: state.count - 1));
  }

  void reset() {
    emit(const CounterState());
  }

  void incrementBy(int value) {
    emit(state.copyWith(count: state.count + value));
  }

  void decrementBy(int value) {
    emit(state.copyWith(count: state.count - value));
  }

  void setCount(int value) {
    emit(state.copyWith(count: value));
  }
}
