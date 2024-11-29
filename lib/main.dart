import 'package:flutter/material.dart';
import 'elements/bottom_navigator.dart';
import 'screens/details_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splashScreen.dart';

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => MainScreen(),
        '/details': (context) => DetailsScreen(),
      },
    );
  }
}
