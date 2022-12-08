
import 'package:flutter/material.dart';
import 'package:Esm3ni/OnBoarding/components/body.dart';


class OnBoardScreen extends StatelessWidget {
  static String routeName = "/OnBoarding";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen

    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 62, 1),
      body: Body(
      ),
    );
  }
}
