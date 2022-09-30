import 'package:my_application/Home.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'RoutePage.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: 'asset/logo-new.png',
        nextScreen: RoutePage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
        duration: 5000,
        splashIconSize: double.infinity,
    );
      //new SplashScreen(
      //seconds: 5, // will display for 5 sec
      //navigateAfterSeconds: routePage(),
      //title: new Text('Welcome to Host4Me', style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
      //image: new Image.asset('asset/logo.jpg'),
      //backgroundColor: Colors.white,
      //photoSize: 200.0,
      //loaderColor: Colors.lightGreen,
    //);
  }
}
