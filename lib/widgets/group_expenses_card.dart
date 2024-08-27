import 'package:flutter/material.dart';
import 'package:split_fe/utils/random_icon_generator.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupExpensesCard extends StatelessWidget {
  final dynamic expense;

  GroupExpensesCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(expense['created_at']);
    String day = DateFormat('dd').format(createdAt);
    String month = DateFormat('MMM').format(createdAt);
    String year = DateFormat('yy').format(createdAt);

    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(child: RandomIcon(), flex: 1),
              SizedBox(width: 20),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense['description'],
                        style: TextStyle(fontSize: 18),
                      ),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${expense['username']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            TextSpan(
                              text: ' paid Rs.',
                              style: TextStyle(fontSize: 15),
                            ),
                            TextSpan(
                              text: '${expense['amount']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  flex: 9),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(day, style: TextStyle(fontSize: 18)),
                      Text(month,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18))
                    ],
                  ),
                  flex: 2),
            ],
          ),
        ),
      ),
      color: Colors.grey[800],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
