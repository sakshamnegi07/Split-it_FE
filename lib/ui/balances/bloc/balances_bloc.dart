import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'balances_event.dart';
import 'balances_state.dart';

class BalancesBloc extends Bloc<BalancesEvent, BalancesState> {
  BalancesBloc() : super(BalancesInitial()) {
    on<FetchBalances>(_onFetchBalances);
    on<RefreshBalances>(_onRefreshBalances);
  }

  Future<void> _onFetchBalances(
      FetchBalances event, Emitter<BalancesState> emit) async {
    emit(BalancesLoading());
    try {
      final balances = await ApiService.getUserBalances();
      emit(BalancesLoaded(balances));
    } catch (error) {
      emit(BalancesError('Failed to fetch balances'));
    }
  }

  Future<void> _onRefreshBalances(
      RefreshBalances event, Emitter<BalancesState> emit) async {
    emit(BalancesLoading());
    try {
      final balances = await ApiService.getUserBalances();
      emit(BalancesLoaded(balances));
    } catch (error) {
      emit(BalancesError('Failed to refresh balances: $error'));
    }
  }
}
