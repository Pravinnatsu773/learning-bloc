part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeMeditaionCategoryFetchSuccess extends HomeState {
  final List<MeditationCategoryModel> meditationCategoryList;

  HomeMeditaionCategoryFetchSuccess({required this.meditationCategoryList});
}

final class HomeMeditaionDataFetchSuccess extends HomeState {
  final List<MeditationDataModel> meditationDataList;

  HomeMeditaionDataFetchSuccess({required this.meditationDataList});
}
