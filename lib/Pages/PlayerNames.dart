import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'MatchDetails.dart';
import 'MatchScreen.dart';

class PlayerNames extends StatefulWidget {
  PlayerNames(this.matchDetailsState);
  final MatchDetailsState matchDetailsState;
  @override
  PlayerNamesState createState() {
    return new PlayerNamesState();
  }
}

class PlayerNamesState extends State<PlayerNames> {
  List<String> teamA = new List();
  List<String> teamB = new List();
  String teamAName, teamBName;
  String name; //temp

  TextEditingController nameTakerController;
  int groupValue; //For RadioButton Toggle

  @override
  void initState() {
    // TODO: implement initState
    nameTakerController = new TextEditingController();
    teamAName = widget.matchDetailsState.tANamecontroller.text;
    teamBName = widget.matchDetailsState.tBNamecontroller.text;
    super.initState();
  }

  void takeName(bool isteamA) {
    showDialog(
        context: this.context,
        child: new SimpleDialog(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                maxLength: 22,
                controller: nameTakerController,
                decoration:
                    new InputDecoration(hintText: "Enter Player's name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new RaisedButton(
                onPressed: () {
                  if (nameTakerController.text != null) {
                    name = nameTakerController.text;
                    (isteamA)
                        ? (setState(() {
                            teamA.add(name);
                          }))
                        : (setState(() {
                            teamB.add(name);
                          }));
                    nameTakerController.text = "";
                    Navigator.pop(context);
                  }
                },
                child: new Text(
                  "Add",
                  style: new TextStyle(fontSize: 20.0),
                ),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final snackBar1 = SnackBar(
      content: new Text("Minimum 2 players required each!"),
    );
    final snackBar2 = SnackBar(
      content: new Text("Select one team!"),
    );
    // TODO: implement build
    return new Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: new IconButton(
          onPressed: () {
            (teamA.length < 2 || teamB.length < 2)
                ? Scaffold.of(context).showSnackBar(snackBar1)
                : (groupValue == null)
                    ? Scaffold.of(context).showSnackBar(snackBar2)
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MatchScreen(this)));
          },
          icon: new Icon(
            FontAwesomeIcons.arrowCircleRight,
            color: Colors.yellow[900],
            size: 48.0,
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[900],
      appBar: new AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 48.0),
              child: new Text(
                'Cricketkeeper',
                style: new TextStyle(color: Colors.white),
              ),
            ),
          ),
          elevation: 0.5,
          backgroundColor: Colors.blueGrey[900]),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
              child: new RaisedButton(
                color: Colors.grey[850],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Text(
                    teamAName + ": Add Player",
                    style: new TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  takeName(true);
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              child: Container(
                decoration: new BoxDecoration(
                    border: new Border(bottom: new BorderSide(width: 0.5))),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: new List<Widget>.generate(teamA.length, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new IconButton(
                            icon: new Icon(Icons.cancel, color: Colors.black45),
                            onPressed: () {
                              setState(() {
                                teamA.removeAt(index);
                              });
                            }),
                        new Text(
                          teamA[index],
                          style: new TextStyle(
                              fontSize: 25.0, color: Colors.yellow[800]),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 48.0),
              child: new RaisedButton(
                color: Colors.grey[850],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Text(
                    teamBName + ": Add Player",
                    style: new TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  takeName(false);
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              child: Container(
                decoration: new BoxDecoration(
                    border: new Border(bottom: new BorderSide(width: 0.5))),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: new List<Widget>.generate(teamB.length, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(Icons.cancel, color: Colors.black45),
                          onPressed: () {
                            setState(() {
                              teamB.removeAt(index);
                            });
                          },
                        ),
                        new Text(
                          teamB[index],
                          style: new TextStyle(
                              fontSize: 25.0, color: Colors.yellow[800]),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Text(
                "Who gets to bat?",
                style: new TextStyle(color: Colors.white70, fontSize: 20.0),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: new RadioListTile(
                    title: new Text(
                      widget.matchDetailsState.tANamecontroller.text,
                      style: new TextStyle(
                          color: Colors.yellow[800], fontSize: 18.0),
                    ),
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (e) {
                      setState(() {
                        groupValue = e;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: new RadioListTile(
                    title: new Text(
                        widget.matchDetailsState.tBNamecontroller.text,
                        style: new TextStyle(
                            color: Colors.yellow[800], fontSize: 18.0)),
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (e) {
                      setState(() {
                        groupValue = e;
                      });
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                "^Preferably, add players in the bowling order^",
                style: new TextStyle(color: Colors.white70),
              ),
            )
          ],
        ),
      ),
    );
  }
}
