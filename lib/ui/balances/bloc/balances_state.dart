abstract class BalancesState {}

class BalancesInitial extends BalancesState {}

class BalancesLoading extends BalancesState {}

class BalancesLoaded extends BalancesState {
  final Map<String, dynamic> balances;

  BalancesLoaded(this.balances);
}

class BalancesError extends BalancesState {
  final String error;

  BalancesError(this.error);
}
