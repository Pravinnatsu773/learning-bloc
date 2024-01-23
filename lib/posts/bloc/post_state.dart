part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

abstract class PostActionstate extends PostState {}

final class PostLoadingSate extends PostState {}

final class PostFetchSuccessState extends PostState {
  final List<PostDataModel> postDataList;

  PostFetchSuccessState({required this.postDataList});
}
