import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/toast.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class RemindDialog extends StatefulWidget {
  final int receiverId;
  final String receiverName;
  final double amount;

  RemindDialog(
      {required this.receiverId,
      required this.receiverName,
      required this.amount});

  @override
  _RemindDialogState createState() => _RemindDialogState();
}

class _RemindDialogState extends State<RemindDialog> {
  bool _isLoading = false;

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  void initState() {
    super.initState();
  }

  void _remindBorrowerByEmail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await ApiService.sendPaymentReminderEmail(
          borrowerId: widget.receiverId, amount: widget.amount);
      ToastService.showToast("Reminder sent successfully!");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ToastService.showToast("Error while sending email!");
      setState(() {
        _isLoading = false;
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading) ...[
              const SizedBox(height: 50),
              CircularProgressIndicator(),
              const SizedBox(height: 50),
            ],
            if (!_isLoading) ...[
              const SizedBox(height: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Remind ',
                              ),
                              TextSpan(
                                text: '${widget.receiverName}',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' for payment of',
                              ),
                            ],
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Rs. ${widget.amount.abs()}',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      )),
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Colors.red[500], // Custom background color
                      ),
                      onPressed: () {
                        _remindBorrowerByEmail();
                      },
                      child: Text('Remind'),
                    ),
                  )
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
