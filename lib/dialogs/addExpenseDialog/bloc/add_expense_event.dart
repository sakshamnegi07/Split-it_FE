abstract class ExpenseEvent {}

class FetchMembers extends ExpenseEvent {
  final int groupId;

  FetchMembers({required this.groupId});
}

class AddExpense extends ExpenseEvent {
  final int groupId;
  final String description;
  final double amount;
  final int paidBy;

  AddExpense({
    required this.groupId,
    required this.description,
    required this.amount,
    required this.paidBy,
  });
}
