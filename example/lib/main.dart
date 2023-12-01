// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage_widget/model/college_type.dart';

import 'src/screens/collage_sample.dart';
import 'src/tranistions/fade_route_transition.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var color = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRaisedButton(CollageType collageType, String text) {
      return ElevatedButton(
        onPressed: () => pushImageWidget(collageType),
        style: ElevatedButton.styleFrom(shape: buttonShape(), backgroundColor: color),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      );
    }

    ///Create multple shapes
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: <Widget>[
            buildRaisedButton(CollageType.vSplit, 'Vsplit'),
            buildRaisedButton(CollageType.hSplit, 'HSplit'),
            buildRaisedButton(CollageType.fourSquare, 'FourSquare'),
            buildRaisedButton(CollageType.nineSquare, 'NineSquare'),
            buildRaisedButton(CollageType.threeVertical, 'ThreeVertical'),
            buildRaisedButton(CollageType.threeHorizontal, 'ThreeHorizontal'),
            buildRaisedButton(CollageType.leftBig, 'LeftBig'),
            buildRaisedButton(CollageType.rightBig, 'RightBig'),
            buildRaisedButton(CollageType.fourLeftBig, 'FourLeftBig'),
            buildRaisedButton(CollageType.vMiddleTwo, 'VMiddleTwo'),
            buildRaisedButton(CollageType.centerBig, 'CenterBig'),
          ],
        ),
      ),
    );
  }

  ///On click of perticular type of button show that type of widget
  pushImageWidget(CollageType type) async {
    await Navigator.of(context).push(
      FadeRouteTransition(page: CollageSample(type)),
    );
  }

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  }
}
