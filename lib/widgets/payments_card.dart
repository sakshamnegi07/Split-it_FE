import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
      color: Colors.grey[800],
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.monetization_on,
                color: Color.fromARGB(
                  255,
                  random.nextInt(256),
                  random.nextInt(256),
                  random.nextInt(256),
                ),
                size: 40,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: paymentData['paid_by_username'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' paid ',
                          style: TextStyle(fontSize: 14),
                        ),
                        TextSpan(
                          text: paymentData['paid_to_username'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (currentUserId == paymentData['paid_by'])
                    Text(
                      'You paid Rs. ${paymentData['amount']}',
                      style: TextStyle(
                          color: Colors.lightGreenAccent, fontSize: 15),
                    ),
                  if (currentUserId == paymentData['paid_to'])
                    Text(
                      'You received Rs. ${paymentData['amount']}',
                      style: TextStyle(
                          color: Colors.lightGreenAccent, fontSize: 15),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(day, style: TextStyle(fontSize: 16)),
                Text(month,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
