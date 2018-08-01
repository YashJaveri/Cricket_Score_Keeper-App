import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Pages/MatchDetails.dart';

main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return new MaterialApp(
        theme: new ThemeData(primaryColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: new MatchDetails());
  }
}

