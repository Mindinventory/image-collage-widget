import 'package:flutter/material.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
import 'src/screens/collage_sample.dart';
import 'src/tranistions/fade_route_transition.dart';

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
  var color = Colors.white;
  List<GlobalKey> globalKeys = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget buildRaisedButton(CollageType collageType, String text, GlobalKey<State<StatefulWidget>> globalKey) {
     return RaisedButton(
        onPressed: () => pushImageWidget(collageType,globalKey),
        shape: buttonShape(),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      );
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 11,
          itemBuilder: (context,index){
            return  Column(
              children: [
                buildRaisedButton(CollageType.VSplit, 'Vsplit',GlobalKey(debugLabel: 'VsplitKey')),
                buildRaisedButton(CollageType.HSplit, 'HSplit',GlobalKey(debugLabel: 'HSplitKey')),
                buildRaisedButton(CollageType.FourSquare, 'FourSquare',GlobalKey(debugLabel: 'FourSquareKey')),
                buildRaisedButton(CollageType.NineSquare, 'NineSquare',GlobalKey(debugLabel: 'NineSquareKey')),
                buildRaisedButton(CollageType.ThreeVertical, 'ThreeVertical',GlobalKey(debugLabel: 'ThreeVerticalKey')),
                buildRaisedButton(CollageType.ThreeHorizontal, 'ThreeHorizontal',GlobalKey(debugLabel: 'ThreeHorizontalKey')),
                buildRaisedButton(CollageType.LeftBig, 'LeftBig',GlobalKey(debugLabel: 'LeftBigKey')),
                buildRaisedButton(CollageType.RightBig, 'RightBig',GlobalKey(debugLabel: 'RightBigKey')),
                buildRaisedButton(CollageType.FourLeftBig, 'FourLeftBig',GlobalKey(debugLabel: 'FourLeftBigKey')),
                buildRaisedButton(CollageType.VMiddleTwo, 'VMiddleTwo',GlobalKey(debugLabel: 'VMiddleTwoKey')),
                buildRaisedButton(CollageType.CenterBig, 'CenterBig',GlobalKey(debugLabel: 'CenterBigKey')),
              ],
            );
          },
          ),
        ),
      ),
    );
  }

  pushImageWidget(CollageType type, GlobalKey<State<StatefulWidget>> globalKey) async {
    await Navigator.of(context).push(
      FadeRouteTransition(page: CollageSample(type,globalKey)),
    );
  }

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0));
  }
}
