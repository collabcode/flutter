import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Items {
  final String name;
  final List<String> value;

  const Items(this.name, this.value);
}

class Children {
  final List<Items> items;

  const Children(this.items);
}

class JsonData {
  final int id;
  final String name;
  final Children children;

  JsonData(this.id, this.name, this.children);
}

//Git Hub 3
void main() {
  runApp(MyApp());
  //loadCrossword();
}

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
  int _counter = 0;
  String _text = "";

  Children children;

  Future<String> _loadAssets() async {
    return await rootBundle.loadString('assets/data/test.json');
  }

  JsonData _parseJson(String jsonString) {
    Map decoded = jsonDecode(jsonString);

    List<Items> items = new List<Items>();
    for (var item in decoded['children']) {
      items.add(new Items(item['name'], item['value'].cast<String>()));
    }
    JsonData j =
        new JsonData(decoded['id'], decoded['name'], new Children(items));

    return j;
  }

  Future _parseAssets() async {
    String jsonString = await _loadAssets();
    JsonData jsonData = _parseJson(jsonString);
    children = jsonData.children;
  }

  void _incrementCounter() {
    _parseAssets();
    setState(() {
      _counter++;
      if (_counter >= children.items[0].value.length) {
        _counter = 0;
      }
      FlutterTts flutterTts = new FlutterTts();
      //_text = String.fromCharCode(_counter);
      _text = children.items[0].value[_counter];

      TtsState ttsState = TtsState.stopped;
      Future _speak() async {
        var result = await flutterTts.speak(_text);
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
            Text(_text,
                //style: Theme.of(context).textTheme.display4,
                style: TextStyle(fontSize: 100).apply(
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
