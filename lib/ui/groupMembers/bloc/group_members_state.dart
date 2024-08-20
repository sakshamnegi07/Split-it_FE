abstract class GroupMembersState {}

class GroupMembersInitial extends GroupMembersState {}

class GroupMembersLoading extends GroupMembersState {}

class GroupMembersLoaded extends GroupMembersState {
  final List<dynamic> groupMembers;

  GroupMembersLoaded(this.groupMembers);
}

class GroupMembersError extends GroupMembersState {
  final String error;

  GroupMembersError(this.error);
}

class MemberRemoved extends GroupMembersState {
  final String message;

  MemberRemoved(this.message);
}
