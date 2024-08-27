import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/add_expense_bloc.dart';
import 'bloc/add_expense_event.dart';
import 'bloc/add_expense_state.dart';
import 'package:split_fe/utils/toast.dart';
import 'package:flutter/services.dart';

class AddExpenseDialog extends StatefulWidget {
  final int groupId;

  AddExpenseDialog({required this.groupId});

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final TextEditingController _expenseDescription = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseBloc()..add(FetchMembers(groupId: widget.groupId)),
      child: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ExpenseAdded) {
            Navigator.pop(context, "Expense Added");
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MembersFetched) {
            return _buildDialog(context, state.members);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildDialog(
      BuildContext context, List<Map<String, dynamic>> members) {
    int? selectedMemberId;

    return Dialog(
        backgroundColor: Colors.grey[900],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: 280,
                  child: DropdownButtonFormField<int>(
                    value: selectedMemberId,
                    onChanged: (int? newValue) {
                      selectedMemberId = newValue;
                    },
                    items: members.map<DropdownMenuItem<int>>(
                        (Map<String, dynamic> member) {
                      return DropdownMenuItem<int>(
                        value: member['id'],
                        child: Text(
                          member['username'],
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      hintText: "Paid by",
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    dropdownColor: Colors.grey[800],
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    isExpanded: true,
                    menuMaxHeight: 200,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 280,
                  child: TextFormField(
                    controller: _expenseDescription,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Enter a description",
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 280,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "₹ 0.0 (Amount)",
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: const Text(
                          "*Split EQUALLY among the current members of the group!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedMemberId == null) {
                          ToastService.showToast(
                              "Select member who paid for the expense!");
                          return;
                        }
                        if (_amountController.text == "") {
                          ToastService.showToast("Enter amount!");
                          return;
                        }
                        if (_expenseDescription.text == "") {
                          ToastService.showToast("Enter expense description!");
                          return;
                        }
                        BlocProvider.of<ExpenseBloc>(context).add(
                          AddExpense(
                            groupId: widget.groupId,
                            description: _expenseDescription.text,
                            amount: double.parse(_amountController.text),
                            paidBy: selectedMemberId!,
                          ),
                        );
                      },
                      child: Text('ADD', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
