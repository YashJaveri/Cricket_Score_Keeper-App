import 'package:flutter/material.dart';
import 'StartScreen.dart';
import 'MatchScreen.dart';

class WinningScreen extends StatefulWidget {
  MatchScreenState _matchScreenState;
  WinningScreen(MatchScreenState matchScreenState) {
    _matchScreenState = matchScreenState;
  }

  @override
  WinningScreenState createState() {
    return new WinningScreenState();
  }
}

class WinningScreenState extends State<WinningScreen> {
  MatchScreenState __matchScreenState;
  @override
  void initState() {
    // TODO: implement initState
    __matchScreenState = widget._matchScreenState;
    super.initState();
  }

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
              padding: const EdgeInsets.fromLTRB(32.0, 220.0, 32.0, 65.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Icon(
                        Icons.add_circle,
                        size: 54.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(
                                    width:5.0, color: Colors.black87))),
                      ),
                    ),
                    Flexible(
                      child: new Text(
                        (__matchScreenState.totalRunsB >=
                          __matchScreenState.targetGiven)
                      ? (__matchScreenState.teamBName +
                          "won by " +
                           (__matchScreenState.totalWicketsB -
                                  __matchScreenState.teamBBatting.length -
                                  1)
                              .toString() + " wickets")
                      : ((__matchScreenState.totalBallsToBePlayed <=
                                      __matchScreenState.ballsA ||
                                  __matchScreenState.totalWicketsB <=
                                      (__matchScreenState.teamBBatting.length -
                                          1)) &&
                              (__matchScreenState.totalRunsB <
                                  __matchScreenState.targetGiven))
                          ? (__matchScreenState.teamAName +
                              "won by " +
                              (__matchScreenState.targetGiven -
                                      __matchScreenState.totalRunsA)
                                  .toString() +
                              " runs")
                          : (__matchScreenState.targetGiven ==
                                      __matchScreenState.totalRunsB &&
                                  __matchScreenState.totalBallsToBePlayed <=
                                      __matchScreenState.ballsA)
                              ? ("It is a Tie")
                              :
                        "Some error occured :(",
                        style: new TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0),
                      ),
                    )
                  ])),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: new FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Start New Match",
                  style:
                      new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StartScreen()));
              },
              color: Colors.yellow[800],
            ),
          ),
          new FlatButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 66.0),
              child: new Text(
                "Exit",
                style:
                    new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StartScreen()));
            },
            color: Colors.white,
          ),
        ],
      )),
    ));
  }
}
