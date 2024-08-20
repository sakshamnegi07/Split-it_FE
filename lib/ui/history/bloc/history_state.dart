abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<dynamic> payments;

  HistoryLoaded(this.payments);
}

class HistoryError extends HistoryState {
  final String error;

  HistoryError(this.error);
}
