import 'dart:async';
import 'package:flutter/material.dart';
import 'package:salon_app/components/bottom_navigationbar.dart';
import 'package:salon_app/screens/introduction/onboarding_screen.dart';
import 'package:salon_app/utils/constants.dart';
import 'package:salon_app/utils/firebase_services.dart';
import 'package:salon_app/utils/functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> implements Presenter {
  bool isAnimate = true;
  bool isClicked = false;

  final width = 50;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), (() {
      setState(() {
        isAnimate = false;
      });
    }));

    Future.delayed(const Duration(milliseconds: 2000), () {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: ((context) => const OnBoardingScreen())));
      // if (spUtil?.services.isEmpty ?? false) {
      //   _fetchServices();
      // } else {
      //   onClick(onSuccess);
      // }
      _fetchServices();
    });

    super.initState();
  }

  _fetchServices() async {
    final services = await FirebaseServices.getServices();
    spUtil?.services = services;
    onClick(onSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 150),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedPadding(
                  padding: EdgeInsets.only(top: isAnimate ? 40 : 0),
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOutCubicEmphasized,
                  child: AnimatedOpacity(
                    opacity: isAnimate ? 0 : 1,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInCubic,
                    child: const CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 80,
                      foregroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlsWQc8piebZMl-wQAD71xoEFovIAxB0bCYURrbrb1y_URNyoW6I0q6QpbKo_Fo6ZBDRw&usqp=CAU"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: isAnimate ? 40 : 0),
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOutCubicEmphasized,
                  child: AnimatedOpacity(
                    opacity: isAnimate ? 0 : 1,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInCubic,
                    child: const Text(
                      "Evita Salon",
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 40,
                          letterSpacing: 1.3,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void onClick(String? action) {
    switch (action) {
      case onSuccess:
        Future.delayed(Duration.zero, () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => (spUtil?.user.uid == null)
                    ? const OnBoardingScreen()
                    : BottomNavigationComponent(),
              ),
              (route) => false);
        });
        break;
    }
  }
}
