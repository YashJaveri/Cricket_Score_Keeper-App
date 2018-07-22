import 'package:flutter/material.dart';
import '../Data/MatchInfo.dart';
import 'PlayerNames.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';

class MatchDetails extends StatefulWidget {
  @override
  MatchDetailsState createState() {
    return new MatchDetailsState();
  }
}

class MatchDetailsState extends State<MatchDetails> {
  TextEditingController tANamecontroller,
      tBNamecontroller,
      totalOversController;
  MatchInfo matchInfoInstance;
  int groupValue; //For RadioButton Toggle

  int _totalOvers = 20;
  int playersInA = 9, playersInB = 9;
  static MatchDetailsState instance;
  // FixedExtentScrollController scrollController = new FixedExtentScrollController(initialItem: 7);
  // List<int> listOfNumbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]; //For CupertinoPicker

  @override
  void initState() {
    // TODO: implement initState
    tANamecontroller = new TextEditingController(text: "Team A");
    tBNamecontroller = new TextEditingController(text: "Team B");
    totalOversController = new TextEditingController(text: "");
    matchInfoInstance = new MatchInfo("", "", 20);

    super.initState();
  }

  void saveInfo(String tAName, String tBName, int totalOvers) {
    matchInfoInstance = new MatchInfo(tAName, tBName, totalOvers);
  }

  MatchInfo get getMatchInfo {
    return matchInfoInstance;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(36.0),
          child: new IconButton(
            onPressed: () {
              _totalOvers = int.parse(totalOversController.text.toString());
              saveInfo(
                  tANamecontroller.text, tBNamecontroller.text, _totalOvers);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PlayerNames(this)));
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
              child: new Text(
                'Cricketkeeper',
                style: new TextStyle(color: Colors.white),
              ),
            ),
            elevation: 0.5,
            backgroundColor: Colors.blueGrey[900]),
        body: new Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 36.0, horizontal: 54.0),
                child: new TextFormField(
                  controller: totalOversController,
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 26.0, color: Colors.white),
                  keyboardType: new TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: new InputDecoration(
                      hintText: "Enter total number of overs",
                      hintStyle: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[350])),
                ),
              ),
              new Row(children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: new TextFormField(
                        controller: tANamecontroller,
                        style: new TextStyle(
                          color: Colors.yellow[800],
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Name",
                            hintStyle: new TextStyle(
                              color: Colors.grey[350],
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                            icon: new Icon(
                              Icons.edit,
                              color: Colors.yellow[900],
                            ))),
                  ),
                ),
                new Flexible(
                  child: new TextFormField(
                      controller: tBNamecontroller,
                      style: new TextStyle(
                        color: Colors.yellow[800],
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Name",
                          hintStyle: new TextStyle(
                            color: Colors.grey[350],
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                          ),
                          icon: new Icon(
                            Icons.edit,
                            color: Colors.yellow[900],
                          ))),
                ),
              ]),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: new NumberPicker.integer(
                      initialValue: playersInA,
                      minValue: 2,
                      maxValue: 20,
                      onChanged: (num value) {
                        setState(() {
                          playersInA = value;
                        });
                      },
                    ),
                  ),
                  new Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: new NumberPicker.integer(
                        initialValue: playersInB,
                        minValue: 2,
                        maxValue: 20,
                        onChanged: (num value) {
                          setState(() {
                            playersInB = value;
                          });
                        },
                      )),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: new Text(
                      "Total players\nin this team: " + playersInA.toString(),
                      style:
                          new TextStyle(color: Colors.white70, fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: new Text(
                      "Total players\nin this team: " + playersInB.toString(),
                      style:
                          new TextStyle(color: Colors.white70, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}
