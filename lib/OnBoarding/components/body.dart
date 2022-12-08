import 'package:Esm3ni/OnBoarding/components/title.dart';
import 'package:flutter/material.dart';
import 'package:Esm3ni/Screens/getStarted.dart';

import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {"text": "Welcome to Esm3ni app", "image": "assets/logo.png"},

  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => TitleHead(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      splashData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  Spacer(flex: 3),
                  DefaultButton(
                    text: "Get Started",
                    press: () {
                      Navigator.pushNamed(context, getStarted.routeName);
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      margin: EdgeInsets.only(right: 5),
      height: 7,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? Color.fromRGBO(113, 48, 148, 1)
            : Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
