import 'package:flutter/material.dart';
import 'package:image_collage_widget/utils/CollageType.dart';

import 'src/screens/collage_sample.dart';
import 'src/tranistions/fade_route_transition.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRaisedButton(CollageType collageType, String text) {
      return RaisedButton(
        onPressed: () => pushImageWidget(collageType),
        shape: buttonShape(),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: <Widget>[
            buildRaisedButton(CollageType.VSplit, 'Vsplit'),
            buildRaisedButton(CollageType.HSplit, 'HSplit'),
            buildRaisedButton(CollageType.FourSquare, 'FourSquare'),
            buildRaisedButton(CollageType.NineSquare, 'NineSquare'),
            buildRaisedButton(CollageType.ThreeVertical, 'ThreeVertical'),
            buildRaisedButton(CollageType.ThreeHorizontal, 'ThreeHorizontal'),
            buildRaisedButton(CollageType.LeftBig, 'LeftBig'),
            buildRaisedButton(CollageType.RightBig, 'RightBig'),
            buildRaisedButton(CollageType.FourLeftBig, 'FourLeftBig'),
            buildRaisedButton(CollageType.VMiddleTwo, 'VMiddleTwo'),
            buildRaisedButton(CollageType.CenterBig, 'CenterBig'),
          ],
        ),
      ),
    );
  }

  pushImageWidget(CollageType type) async {
    await Navigator.of(context).push(
      FadeRouteTransition(page: CollageSample(type)),
    );
  }



  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  }
}
