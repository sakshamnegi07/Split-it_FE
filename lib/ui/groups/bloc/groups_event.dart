abstract class GroupEvent {}

class FetchGroups extends GroupEvent {}

class CreateGroup extends GroupEvent {
  final String groupName;
  final String groupDescription;

  CreateGroup({required this.groupName, required this.groupDescription});
}
