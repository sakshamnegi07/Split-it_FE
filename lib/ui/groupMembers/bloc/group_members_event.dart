abstract class GroupMembersEvent {}

class FetchGroupMembers extends GroupMembersEvent {
  final int groupId;

  FetchGroupMembers({required this.groupId});
}

class RemoveMember extends GroupMembersEvent {
  final int groupId;
  final int userId;

  RemoveMember({required this.groupId, required this.userId});
}
