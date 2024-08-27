import 'package:flutter/material.dart';
import 'package:split_fe/ui/landingPage/landingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:split_fe/ui/home/home.dart';
import 'package:split_fe/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token != null && await ApiService.isTokenValid(token)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LandingScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
