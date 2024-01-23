part of 'quotes_cubit.dart';

@immutable
sealed class QuotesState {}

final class QuotesInitial extends QuotesState {}

final class QuotesDataFetchSuccess extends QuotesState {
  final List<QuotesDataModel> quotesDataList;

  QuotesDataFetchSuccess({required this.quotesDataList});
}
