import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MyApp());

enum TtsState { playing, stopped }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demo'),
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
  int _counter = 65;

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter > 90) {
        _counter = 65;
      }
      FlutterTts flutterTts = new FlutterTts();

      TtsState ttsState = TtsState.stopped;
      Future _speak() async {
        var result = await flutterTts.speak(String.fromCharCode(_counter));
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }

      _speak();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(String.fromCharCode(_counter),
                //style: Theme.of(context).textTheme.display4,
                style: TextStyle(fontSize: 500).apply(
                    color: Color.fromRGBO(
                        1 * (new Random().nextInt(255)),
                        10 * (new Random().nextInt(255)),
                        10 * (new Random().nextInt(255)),
                        100))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.arrow_forward_ios),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
