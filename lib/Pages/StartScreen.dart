import 'package:flutter/material.dart';
import 'MatchDetails.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("android/Assets/Untitled-1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: new Column(
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0,170.0,0.0,25.0),
              child: new Icon(Icons.add_circle,size: 165.0,),
            ),
        new FlatButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Start Match",
              style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () { Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MatchDetails()));},
          color: Colors.yellow[800],
        ),
      ])),
    ));
  }
}
