import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/toast.dart';

class AddExpenseDialog extends StatefulWidget {
  final int groupId;

  AddExpenseDialog({required this.groupId});

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final TextEditingController _expenseDescription = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _addExpense() async {
    try {
      final data = await ApiService.addExpenseToGroup(
          groupId: widget.groupId,
          amount: double.parse(_amountController.text),
          description: _expenseDescription.text);
      ToastService.showToast("Expense added successfully!");
    } catch (e) {
      ToastService.showToast("Error adding expense!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: const Text(
                      "*Paid by YOU and split EQUALLY among the current members of the group!",
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
                    _addExpense();
                    Navigator.pop(context, "Pressed!");
                  },
                  child: Text('ADD',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 17)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
