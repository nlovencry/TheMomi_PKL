import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'login_page.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/icon/icon_splash.png',
          height: 250,
          width: 250,
        ),
        SizedBox(height: 15),
        const Text('The Momi', style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold,
            color: Color(0xFFE8CB79)
        ),),
      ],
    ),
      backgroundColor: Colors.black,
      nextScreen: const LoginPage(),
      splashIconSize: 315,
      duration: 3000,
      // splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 3),
    );
  }
}
