
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class MembersFetched extends ExpenseState {
  final List<Map<String, dynamic>> members;

  MembersFetched({required this.members});
}

class ExpenseAdded extends ExpenseState {}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError({required this.message});
}

