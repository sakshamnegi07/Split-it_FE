abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<dynamic> groups;

  GroupsLoaded(this.groups);
}

class GroupCreated extends GroupState {}

class GroupError extends GroupState {
  final String error;

  GroupError(this.error);
}
