import 'package:bloc/bloc.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';
import 'package:split_fe/services/api_service.dart';
import 'package:split_fe/utils/toast.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<FetchMembers>(_onFetchMembers);
    on<AddExpense>(_onAddExpense);
  }

  void _onFetchMembers(FetchMembers event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final members = await ApiService.getGroupMembers(groupId: event.groupId);
      emit(MembersFetched(members: List<Map<String, dynamic>>.from(members)));
    } catch (e) {
      emit(ExpenseError(message: "Error fetching members!"));
    }
  }

  void _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final data = await ApiService.addExpenseToGroup(
        groupId: event.groupId,
        amount: event.amount,
        description: event.description,
        paidBy: event.paidBy,
      );

      if (!data.containsKey("error")) {
        ToastService.showToast("Expense added successfully!");
        emit(ExpenseAdded());
      } else {
        emit(ExpenseError(message: data["error"]));
      }
    } catch (e) {
      emit(ExpenseError(message: "Failed to add expense!"));
    }
  }
}
