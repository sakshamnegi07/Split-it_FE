import 'package:flutter/material.dart';
import 'package:split_fe/dialogs/remindDialog.dart';
import 'package:split_fe/dialogs/settleUpDialog.dart';
import 'package:google_fonts/google_fonts.dart';

class BalancesCard extends StatelessWidget {
  final dynamic balance;
  final Function onDialogClose;

  BalancesCard({required this.balance, required this.onDialogClose});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    balance['borrower_name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: balance['total_amount'].toDouble() > 0.0
                                ? 'You are owed'
                                : balance['total_amount'].toDouble() < 0.0
                                    ? 'You owe'
                                    : 'You are settled up!',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: balance['total_amount'].toDouble() != 0.0
                                ? ' Rs. ${balance['total_amount'].abs()}'
                                : '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (balance['total_amount'].toDouble() < 0.0)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[600],
                    ),
                    onPressed: () async {
                      final result = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => SettleUpDialog(
                              receiverId: balance['borrower_id'],
                              receiverName: balance['borrower_name'],
                              amount:
                                  balance['total_amount'].toDouble().abs()));

                      if (result == "Settled") onDialogClose();
                    },
                    child: Text('Settle up!')),
              if (balance['total_amount'].toDouble() > 0.0)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[500],
                    ),
                    onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => RemindDialog(
                            receiverId: balance['borrower_id'],
                            receiverName: balance['borrower_name'],
                            amount: balance['total_amount'].toDouble())),
                    child: Text('Remind!'))
            ],
          ),
        ),
      ),
      color: Colors.grey[800],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
