import 'package:flutter/material.dart';
import 'dart:math';

class PaymentsCard extends StatelessWidget {
  final random = Random();
  final dynamic paymentData;
  final int? currentUserId;

  PaymentsCard({required this.paymentData, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(Icons.monetization_on,
                  color: Color.fromARGB(
                    255,
                    random.nextInt(256),
                    random.nextInt(256),
                    random.nextInt(256),
                  ),
                  size: 50),
              SizedBox(width: 20),
              Column(
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