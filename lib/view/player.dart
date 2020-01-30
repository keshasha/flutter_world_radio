import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:volume/volume.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  String url;
  bool isPlaying;
  double _sliderValue = 0.0;
  Future<List> urls;
  int currentIndex;

  int maxVol, currentVol;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    initPlatformState();
    audioStart();
  }

  @override
  void dispose() {
    FlutterRadio.stop();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    // pass any stream as parameter as per requirement
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i);
  }

  Future<void> audioStart() async {
    urls = loadJsonUrls();
    await FlutterRadio.audioStart();
    print("Radio started");
  }

  Future<List> loadJsonUrls() async {
    var jsonUrls = await rootBundle.loadString('assets/urls.json');
    return json.decode(jsonUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey.shade900,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<List>(
                  future: urls,
                  builder: (context, snapshot) {
                    var urls = snapshot.data;
                    if (snapshot.hasData) {
                      return ListView.builder(
                          controller: scrollController,
                          itemCount: urls.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                print("${urls[index]["name"]}");
                                if (isPlaying) {
                                  FlutterRadio.stop();
                                }
                                setState(() {
                                  currentIndex = index;
                                  url = urls[index]["url"];
                                });
                                FlutterRadio.play(url: url);
                                isPlaying = true;
                              },
                              child: Card(
                                color: currentIndex == index
                                    ? Colors.indigo.shade300
                                    : Colors.indigo,
                                child: ListTile(
                                  title: Text(
                                    "${urls[index]["name"]}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          urls.then((urlList) {
                            if (currentIndex <= 0) {
                              currentIndex = urlList.length - 1;
                            } else {
                              currentIndex--;
                            }
                            url = urlList[currentIndex]["url"];
                            scrollController.animateTo(
                                currentIndex.toDouble() * 50,
                                duration: Duration(seconds: 1),
                                curve: Curves.ease);
                            FlutterRadio.stop();
                            FlutterRadio.play(url: url);
                          });
                        });
                      },
                      child: Icon(Icons.skip_previous,
                          size: 80, color: Colors.white)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isPlaying) {
                          FlutterRadio.stop();
                        } else {
                          FlutterRadio.play(url: url);
                        }
                        isPlaying = !isPlaying;
                      });
                    },
                    child: isPlaying
                        ? Icon(
                            Icons.pause_circle_outline,
                            size: 80,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 80,
                          ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          urls.then((urlList) {
                            if (currentIndex >= urlList.length - 1) {
                              currentIndex = 0;
                            } else {
                              currentIndex++;
                            }
                            url = urlList[currentIndex]["url"];
                            scrollController.animateTo(
                                currentIndex.toDouble() * 50,
                                duration: Duration(seconds: 1),
                                curve: Curves.ease);
                            FlutterRadio.stop();
                            FlutterRadio.play(url: url);
                          });
                        });
                      },
                      child:
                          Icon(Icons.skip_next, size: 80, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Slider(
                activeColor: Colors.indigoAccent,
                min: 0.0,
                max: 15.0,
                onChanged: (newRating) async {
                  setState(() {
                    _sliderValue = newRating;
                  });
                  await setVol(newRating.toInt());
                  await updateVolumes();
                },
                value: _sliderValue,
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}
