import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_package/CollageSample.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Directory _directory;
  var color = Colors.white;

  @override
  void initState() {
    super.initState();
    getPath();
  }

  getPath() async {
    _directory = await getExternalStorageDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: <Widget>[
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.VSplit),
              shape: buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Vsplit"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.HSplit),
              shape: buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("HSplit"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.FourSquare),
              shape: buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("FourSquare"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.NineSquare),
              shape: buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("NineSquare"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.ThreeVertical),
              shape: buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ThreeVertical"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.ThreeHorizontal),
              color: color,
              shape: buttonShape(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ThreeHorizontal"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.LeftBig),
              shape: buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("LeftBig"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.RightBig),
              shape: buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("RightBig"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.FourLeftBig),
              shape:  buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("FourLeftBig"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.VMiddleTwo),
              shape:  buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("VMiddleTwo"),
              ),
            ),
            RaisedButton(
              onPressed: () => pushImageWidget(CollageType.CenterBig),
              shape:  buttonShape(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("CenterBig"),
              ),
            )
          ],
        ),
      ),
    );
  }

  pushImageWidget(CollageType type) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => CollageSample(type)));
  }

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0));
  }
}
