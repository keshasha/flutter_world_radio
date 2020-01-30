import 'package:flutter/material.dart';
import 'package:world_radio/view/player.dart';
import 'package:world_radio/view/test_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Radio App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.indigo
      ),
      home: MyHomePage(title: 'World Radio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body: Player()
    );
  }
}
