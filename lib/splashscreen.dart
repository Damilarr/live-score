import 'package:flutter/material.dart';
import 'package:live_score/home/homepage.dart';
import 'package:live_score/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    navigateToPage();
  }

  navigateToPage() async {
    await Future.delayed(Duration(milliseconds: 3000), (() {}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showHome = prefs.getBool('showHome') ?? false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => showHome ? Homepage() : Onboarding(),
      ),
    );
  }

  navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 3000), (() {}));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_soccer_sharp, color: Colors.blue[600], size: 60),
            Text(
              "Swift Score",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
