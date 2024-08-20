import 'package:flutter/material.dart';
import 'package:split_fe/utils/random_icon_generator.dart';

class GroupExpensesCard extends StatelessWidget {
  final dynamic expense;

  GroupExpensesCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              RandomIcon(),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense['description'],
                    style: TextStyle(fontSize: 18),
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      color: Colors.grey[800],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}