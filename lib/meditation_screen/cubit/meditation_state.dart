part of 'meditation_cubit.dart';

@immutable
sealed class MeditationState {}

final class MeditationInitial extends MeditationState {}

final class MeditaionDataFetchSuccess extends MeditationState {
  final List<MeditationDataModel> meditationDataList;

  MeditaionDataFetchSuccess({required this.meditationDataList});
}
