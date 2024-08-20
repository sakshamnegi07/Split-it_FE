abstract class GroupDetailsState {}

class GroupDetailsInitial extends GroupDetailsState {}

class GroupDetailsLoading extends GroupDetailsState {}

class GroupDetailsLoaded extends GroupDetailsState {
  final List<dynamic> groupExpenses;
  final double overallGroupBalance;

  GroupDetailsLoaded({required this.groupExpenses, required this.overallGroupBalance});
}

class GroupDetailsError extends GroupDetailsState {
  final String error;

  GroupDetailsError(this.error);
}

class ExpenseAdded extends GroupDetailsState {}

class MemberAdded extends GroupDetailsState {}
