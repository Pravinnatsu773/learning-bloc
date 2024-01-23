part of 'group_cubit.dart';

@immutable
sealed class GroupState {}

final class GroupInitial extends GroupState {}

final class GroupDataFetchSuccess extends GroupState {
  final List<GroupModel> groups;

  GroupDataFetchSuccess({required this.groups});
}
