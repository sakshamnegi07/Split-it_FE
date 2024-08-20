import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class PaymentsCard extends StatelessWidget {
  final random = Random();
  final dynamic paymentData;
  final int? currentUserId;

  PaymentsCard({required this.paymentData, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(paymentData['paid_at']);
    String day = DateFormat('dd').format(createdAt);
    String month = DateFormat('MMM').format(createdAt);
    String year = DateFormat('yy').format(createdAt);

    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(child: Icon(Icons.monetization_on,
                  color: Color.fromARGB(
                    255,
                    random.nextInt(256),
                    random.nextInt(256),
                    random.nextInt(256),
                  ),
                  size: 50), flex: 2),
              SizedBox(width: 20),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: paymentData['paid_by_username'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' paid ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextSpan(
                              text: paymentData['paid_to_username'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (currentUserId == paymentData['paid_by'])
                        Text('You paid Rs. ${paymentData['amount']}',
                            style: TextStyle(
                                color: Colors.lightGreenAccent, fontSize: 17)),
                      if (currentUserId == paymentData['paid_to'])
                        Text('You received Rs. ${paymentData['amount']}',
                            style: TextStyle(
                                color: Colors.lightGreenAccent, fontSize: 17)),
                    ],
                  ),
                ],
              ), flex: 8),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(day, style: TextStyle(fontSize: 18)),
                      Text(month, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
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