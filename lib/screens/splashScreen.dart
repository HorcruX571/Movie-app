import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation controller
    _scaleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Pop-out scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    // Start scale animation
    _scaleController.forward().then((value) {
      // Navigate to home page after animation
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, const Color.fromARGB(169, 138, 5, 5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Image.asset(
                  'lib/assets/splash.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
