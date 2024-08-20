abstract class GroupDetailsEvent {}

class FetchGroupDetails extends GroupDetailsEvent {
  final int groupId;

  FetchGroupDetails({required this.groupId});
}

class AddExpense extends GroupDetailsEvent {
  final int groupId;
  final String description;
  final double amount;

  AddExpense({required this.groupId, required this.description, required this.amount});
}

class AddMember extends GroupDetailsEvent {
  final int groupId;
  final int memberId;

  AddMember({required this.groupId, required this.memberId});
}
