import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bahm/features/auth/presentation/screens/login_screen.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  @override
  void initState() {
    super.initState();

    // Animation sequence for loader
    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _a = true;
      });
    });
    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _b = true;
      });
    });
    Timer(const Duration(milliseconds: 1300), () {
      setState(() {
        _c = true;
      });
    });
    Timer(const Duration(milliseconds: 1700), () {
      setState(() {
        _e = true;
      });
    });
    Timer(const Duration(milliseconds: 3400), () {
      setState(() {
        _d = true;
      });
    });
    Timer(const Duration(milliseconds: 3850), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;

  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: _d ? 900 : 2500),
              curve: _d ? Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
              height: _d
                  ? 0
                  : _a
                  ? _h / 2
                  : 20,
              width: 20,
            ),
            AnimatedContainer(
              duration: Duration(
                  seconds: _d
                      ? 1
                      : _c
                      ? 2
                      : 0),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _d
                  ? _h
                  : _c
                  ? 80
                  : 20,
              width: _d
                  ? _w
                  : _c
                  ? 200
                  : 20,
              decoration: BoxDecoration(
                  color: _b ? Colors.white : Colors.transparent,
                  borderRadius:
                  _d ? BorderRadius.only() : BorderRadius.circular(30)),
              child: Center(
                child: _e
                    ? AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    FadeAnimatedText(
                      'BAHM',
                      duration: const Duration(milliseconds: 1700),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
