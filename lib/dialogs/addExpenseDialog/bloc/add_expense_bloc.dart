import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  AddExpenseBloc() : super(AddExpenseInitial()) {
    on<AddExpenseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
