
import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:Esm3ni/Words/ArabicUtils.dart' as ArabicUtils;

class Speech extends StatefulWidget {
  static String routeName = "/Speech";
  @override
  _SpeechState createState() => _SpeechState();
}

class _SpeechState extends State<Speech> {

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _img = 'space';
  String _ext = '.png';
  String _path = 'assets/';
  String _displaytext = 'Press the button and start speaking...';
  int _state = 0;
  ScrollController _controller = ScrollController();
  static var _text = 'Press the Listen button and start speaking';
  double _confidence = 1.0;

  String _message = '';
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void add(String str, int i) {
    setState(() {
    //  message.add(MessageStyle(str, i));
      Timer(Duration(milliseconds: 100), () {
        _controller.animateTo(_controller.position.maxScrollExtent,
            duration: Duration(microseconds: 50), curve: Curves.easeOut);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Color.fromRGBO(113, 48, 148, 1),
      ),
      backgroundColor: const Color.fromRGBO(36, 36, 62, 1),
      body: RefreshIndicator(

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image(
                      image: AssetImage('$_path$_img$_ext'),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      key: ValueKey<int>(_state),
                      width: MediaQuery.of(context).size.width,
                      height: (4/3) * MediaQuery.of(context).size.width,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: (4/3) * MediaQuery.of(context).size.width,
                ),

                const Divider(
                  thickness: 2,
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                  child: SingleChildScrollView(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: 0.04 * MediaQuery.of(context).size.height,
                      child: Text(
                        _displaytext,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),

                const Divider(
                  thickness: 2,
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),

              ],
            ),
          ),
        ),

        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
                () { setState(() {
              _text = '';
              _path = 'assets/';
              _img = 'space';
              _ext = '.png';
              _displaytext = 'Press the button and start speaking...';
              _state = 0;
            }); },
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          AvatarGlow(
            animate: _isListening,
            glowColor: Theme
                .of(context)
                .primaryColor,
            endRadius: 60.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: Tooltip(
              message: 'press again to stop',
              child: FloatingActionButton.extended(
                heroTag: "listen",
                onPressed: () {
                  _listen();
                },
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: 25,
                ),
                label: Text(_isListening ? "Stop" : "Listen",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _listen() async {
    if (!_isListening) {
      // print('ana hana');
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      print(available);
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'ar',
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);

            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      translation(_text);
      _state=0;

      if (_text != null)
        add(_text, 0);
      else
        _listen();
      _text = "**We couldn't hear you, try again...**";
    }
  }
  void translation(String _text) async {

    _displaytext = '';
    String speechStr = _text.toLowerCase();

    List<String> strArray = speechStr.split(" ");
    for (String content in strArray) {

      if (ArabicUtils.words.contains(content)){
        String file = content;
        int idx = ArabicUtils.words.indexOf(content);
        int _duration = int.parse(ArabicUtils.words.elementAt(idx+1));
        // print('$_duration');
        setState(() {
          _state += 1;
          _displaytext += content;
          _path = 'assets/arabicwords/';
          _img = file;
          _ext = '.gif';
        });
        await Future.delayed(Duration(milliseconds: _duration));
      } else {
        String file = content;
        if(ArabicUtils.phrases.contains(file)){
          file = 'أنا فرحان';
          int idx = ArabicUtils.words.indexOf(file);
          int _duration = int.parse(ArabicUtils.words.elementAt(idx+1));
          // print('$_duration');
          setState(() {
            _state += 1;
            _displaytext += content;
            _path = 'assets/ArabicPhrases/';
            _img = file;
            _ext = '.gif';
          });
          await Future.delayed(Duration(milliseconds: _duration));

        } else if(ArabicUtils.words.contains(file)) {
          file = 'اهلا';
          int idx = ArabicUtils.words.indexOf(file);
          int _duration = int.parse(ArabicUtils.words.elementAt(idx+1));
          // print('$_duration');
          setState(() {
            _state += 1;
            _displaytext += content;
            _path = 'assets/arabicwords/';
            _img = file;
            _ext = '.gif';
          });
          await Future.delayed(Duration(milliseconds: _duration));
        }
        else {
          for (var i = 0; i < content.length; i++){
            if (ArabicUtils.letters.contains(content[i])) {
              String char = content[i];
              // print('$alphabet');
              setState(() {
                _state += 1;
                _displaytext += char;
                _path = 'assets/ArabicLetters/';
                _img = char;
                _ext = '.gif';
              });
              await Future.delayed(const Duration(milliseconds: 1500));

            } else {
              String letter = content[i];
              // print('$letter');
              setState(() {
                _state += 1;
                _displaytext += letter;
                _path = 'assets/';
                _img = 'space';
                _ext = '.png';
              });
              await Future.delayed(const Duration(milliseconds: 1000));

            }
          }
        }
      }
      // _display_text += ' ';
      setState(() {
        _state += 1;
        _displaytext += " ";
        _path = 'assets/';
        _img = 'space';
        _ext = '.png';
      });
      await Future.delayed(const Duration(milliseconds: 1000));

    }
  }

}

List<String> filterKnownStr(String speechStr, List<String> islGif, List<String> finalArr) {

  bool check = true;

  for (String known in islGif) {
    List<String> tmp;
    if (speechStr.contains(known)){
      check = false;
      tmp = speechStr.split(known);
      tmp[0] = tmp[0].trim();
      finalArr.addAll(tmp[0].split(' '));
      finalArr.add(known);

      if (finalArr.isEmpty){
        finalArr =  ['null'];
      }
      if (tmp.length == 1) {
        return finalArr;
      }
      tmp[1] = tmp[1].trim();
      if (tmp[1] != ''){
        return filterKnownStr(tmp[1], islGif, finalArr);
      } else{
        return finalArr;
      }
    }
  }
  if (check) {
    List<String> tmp = speechStr.split(" ");
    finalArr.addAll(tmp);
    return finalArr;
  }
  return [];
}

