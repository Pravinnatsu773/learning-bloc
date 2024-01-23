part of 'counter_bloc.dart';

@immutable
sealed class CounterEvent {}

final class CounterIncrementEvent extends CounterEvent {}

final class CounterDecrementEvent extends CounterEvent {}
