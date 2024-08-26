import 'package:flutter/material.dart';
import 'package:split_fe/ui/login/login.dart';
import 'package:split_fe/ui/register/register.dart';
import 'package:split_fe/ui/landingPage/landingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(80)),
                    child: Image.asset('assets/images/logo.png')),
              ),
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()));
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
