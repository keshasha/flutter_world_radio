import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:youtube_extractor/youtube_extractor.dart';


class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
//  String url;
//  String url =  "http://server-23.stream-server.nl:8438";
  String url =  "https://ia802708.us.archive.org/3/items/count_monte_cristo_0711_librivox/count_of_monte_cristo_001_dumas.mp3";
  bool isPlaying = false;
  bool isVisible = true;
  var extractor = YouTubeExtractor();
  @override
  void initState() {
    super.initState();
    audioStart();
  }

  Future<void> audioStart() async{
    await FlutterRadio.audioStart();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade900,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Icon(
              Icons.radio, size: 250,
              color: Colors.white,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Align(
                alignment: FractionalOffset.center,
                child: IconButton(icon: isPlaying? Icon(
                  Icons.pause_circle_outline,
                  size: 80,
                  color: Colors.white,
                )
                    : Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 80,
                ),
                  onPressed: (){
                    setState(() {
                      FlutterRadio.play(url: url);
                      isPlaying = !isPlaying;
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 50,)
        ],
    ));
  }
}

