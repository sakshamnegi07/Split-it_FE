import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<FetchHistory>(_onFetchHistory);
    on<RefreshHistory>(_onRefreshHistory);
  }

  Future<void> _onFetchHistory(FetchHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final payments = await ApiService.getPaymentHistory();
      emit(HistoryLoaded(payments));
    } catch (error) {
      emit(HistoryError('Failed to fetch history: $error'));
    }
  }

  Future<void> _onRefreshHistory(RefreshHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final payments = await ApiService.getPaymentHistory();
      emit(HistoryLoaded(payments));
    } catch (error) {
      emit(HistoryError('Failed to refresh history: $error'));
    }
  }
}
