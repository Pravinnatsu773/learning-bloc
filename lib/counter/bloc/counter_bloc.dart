import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementEvent>((event, emit) {
      emit(state + 1);
    });

    on<CounterDecrementEvent>((event, emit) => emit(state - 1));
  }
}
