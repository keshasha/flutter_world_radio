import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String url =
      "https://ia802708.us.archive.org/3/items/count_monte_cristo_0711_librivox/count_of_monte_cristo_001_dumas.mp3";

  @override
  void initState() {
    super.initState();
    audioStart();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        FlatButton(
          child: Icon(Icons.play_circle_filled, size: 100,),
          onPressed: () => FlutterRadio.play(url: url),
        ),
        FlatButton(
          child: Icon(Icons.pause_circle_filled, size: 100,),
          onPressed: () => FlutterRadio.pause(),
        )
      ],
    ));
  }
}
