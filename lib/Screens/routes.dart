
import 'package:Esm3ni/Screens/STT/ArSTT.dart';
import 'package:Esm3ni/Screens/STT/EgSTT.dart';
import 'package:Esm3ni/OnBoarding/onBoard.dart';
import 'package:flutter/widgets.dart';
import 'package:Esm3ni/Screens/getStarted.dart';
import 'getStarted.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  OnBoardScreen.routeName: (context) => OnBoardScreen(),
  getStarted.routeName: (context) => getStarted(),
  SpeechScreen.routeName: (context) => SpeechScreen(),
  Speech.routeName:  (context) => Speech(),
 
};
