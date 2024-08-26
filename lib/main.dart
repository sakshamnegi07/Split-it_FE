import 'package:flutter/material.dart';
import 'ui/login/login.dart';
import 'ui/register/register.dart';
import 'ui/home/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:split_fe/ui/splashscreen/splashscreen.dart';
import 'package:split_fe/services/api_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  ApiService.setupInterceptors();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Colors.black87,
        primaryTextTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      home: SplashScreen(),
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
