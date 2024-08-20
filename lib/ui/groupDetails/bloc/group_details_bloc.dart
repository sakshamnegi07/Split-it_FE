import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'group_details_event.dart';
import 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  GroupDetailsBloc() : super(GroupDetailsInitial()) {
    on<FetchGroupDetails>(_onFetchGroupDetails);
    on<AddExpense>(_onAddExpense);
    on<AddMember>(_onAddMember);
  }

  Future<void> _onFetchGroupDetails(FetchGroupDetails event, Emitter<GroupDetailsState> emit) async {
    emit(GroupDetailsLoading());
    try {
      final expenses = await ApiService.getGroupExpenses(groupId: event.groupId);
      final balance = await ApiService.getOverallGroupBalance(groupId: event.groupId);
      emit(GroupDetailsLoaded(groupExpenses: expenses, overallGroupBalance: balance));
    } catch (error) {
      emit(GroupDetailsError('Failed to fetch group details: $error'));
    }
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<GroupDetailsState> emit) async {
    try {
      emit(ExpenseAdded());
      add(FetchGroupDetails(groupId: event.groupId));
    } catch (error) {
      emit(GroupDetailsError('Failed to add expense: $error'));
    }
  }

  Future<void> _onAddMember(AddMember event, Emitter<GroupDetailsState> emit) async {
    try {
      emit(MemberAdded());
      add(FetchGroupDetails(groupId: event.groupId));
    } catch (error) {
      emit(GroupDetailsError('Failed to add member: $error'));
    }
  }
}
