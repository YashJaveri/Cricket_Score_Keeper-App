import 'package:flutter/material.dart';
import '../MatchScreen.dart';

class WicketManager extends StatefulWidget {
  WicketManager(this._matchScreen);
  final MatchScreenState _matchScreen;
  @override
  WicketManagerState createState() {
    return new WicketManagerState();
  }
}

class WicketManagerState extends State<WicketManager> {
  int tempOnStrike;
  int tempNonStrike;
  int preWicketRun = 0;
  List<String> tempOnStrikeList = new List();
  List<String> tempNonStrikeList = new List();


  @override
  Widget build(BuildContext context) {
    MatchScreenState __matchScreen;
    __matchScreen = widget._matchScreen;

    // TODO: implement build
    return new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      new Text("Who's on strike?", style: new TextStyle(fontSize: 15.0)),
      new Column(
          children: List<Widget>.generate(__matchScreen.teamBatting.length - 1,
              (index) {
        return (__matchScreen.teamBatting[index].player["Out"] == false)
            ? (new CheckboxListTile(
                title: new Text(
                  __matchScreen.teamBatting[index].player["Name"].toString(),
                  style: new TextStyle(color: Colors.blueGrey[900]),
                ),
                value: tempOnStrikeList
                    .contains(__matchScreen.teamBatting[index].player["Name"]),
                onChanged: (bool value) {
                  setState(() {
                    tempOnStrikeList.clear();
                    tempOnStrikeList
                        .add(__matchScreen.teamBatting[index].player["Name"]);
                    __matchScreen.tempOnStrike = (value) ? index : null;
                  });
                }))
            : new Container();
      })),
      new Text("Who's non-striker?", style: new TextStyle(fontSize: 15.0)),
      new Column(
          children: List<Widget>.generate(__matchScreen.teamBatting.length - 1,
              (index) {
        return (__matchScreen.teamBatting[index].player["Out"] == false)
            ? (new CheckboxListTile(
                title: new Text(
                    __matchScreen.teamBatting[index].player["Name"].toString(),
                    style: new TextStyle(color: Colors.blueGrey[900])),
                value: tempNonStrikeList
                    .contains(__matchScreen.teamBatting[index].player["Name"]),
                onChanged: (bool value) {
                  setState(() {
                    tempNonStrikeList.clear();
                    tempNonStrikeList
                        .add(__matchScreen.teamBatting[index].player["Name"]);
                    __matchScreen.tempNonStrike = (value) ? index : null;
                  });
                }))
            : new Container();
      })),
    ]);
  }
}
