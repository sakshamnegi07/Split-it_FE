import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class SettleUpDialog extends StatefulWidget {
  final int receiverId;
  final String receiverName;
  final double amount;

  SettleUpDialog(
      {required this.receiverId,
      required this.receiverName,
      required this.amount});

  @override
  _SettleUpDialogState createState() => _SettleUpDialogState();
}

class _SettleUpDialogState extends State<SettleUpDialog> {
  String senderName = '';
  int senderId = 0;
  bool _isLoading=false;

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
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      senderName = prefs.getString('userName') ?? '';
      senderId = prefs.getInt('userId') ?? 0;
    });
  }

  void _settleBalance() async {
    setState(() {
      _isLoading=true;
    });
    try {
      final data = await ApiService.settleBalance(
          receiverId: widget.receiverId,
          amount: widget.amount.abs());
      ToastService.showToast("Settled up successfully!");
      setState(() {
        _isLoading=false;
      });
    } catch (e) {
      ToastService.showToast("Error settling up!");
      setState(() {
        _isLoading=false;
      });
    }
    Navigator.pop(context, "Settled");
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
            if(_isLoading) ...[
              const SizedBox(height: 50),
              CircularProgressIndicator(),
              const SizedBox(height: 50),
            ],
            if(!_isLoading) ...[
              const SizedBox(height: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: getRandomColor(),
                            child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text('${senderName}'),
                        ],
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_forward, size: 30, color: Colors.white),
                      SizedBox(width: 16),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: getRandomColor(),
                            child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text('${widget.receiverName}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Rs. ${widget.amount.abs()}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                            style: TextStyle(color: Colors.white, fontSize: 16)),
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
                        Colors.green[600], // Custom background color
                      ),
                      onPressed: (){
                        _settleBalance();
                      },
                      child: Text('Settle'),
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
