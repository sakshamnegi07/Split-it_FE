import 'package:flutter/material.dart';
import 'package:split_fe/ui/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutDialog extends StatefulWidget {
  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (Route<dynamic> route) => false,
    );
    // Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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
                height: 100,
                child: Center(
                    child:
                        Text("Are you sure?", style: TextStyle(fontSize: 20)))),
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
                    _logout();
                  },
                  child: Text('Logout',
                      style: TextStyle(
                          color: Colors.red[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
