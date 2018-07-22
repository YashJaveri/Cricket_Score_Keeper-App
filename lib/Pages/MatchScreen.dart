import 'package:flutter/material.dart';
import 'package:flutter_app/Data/PlayerData.dart';
import 'package:flutter_app/Data/BallerData.dart';
import 'package:flutter_app/Data/BallwiseData.dart';
import 'PlayerNames.dart';
import 'package:flutter/services.dart';
import 'Popup/WicketManager.dart';

enum case_Each_Ball {
  dot,
  Singles,
  Doubles,
  Triples,
  Four,
  Six,
  WD,
  WD4,
  Five,
  OUT,
  NB,
  undo
}

class MatchScreen extends StatefulWidget {
  MatchScreen(this.playerNameState);
  final PlayerNamesState playerNameState;
  @override
  MatchScreenState createState() => new MatchScreenState();
}

class MatchScreenState extends State<MatchScreen> {
  List<PlayerData> teamA_Batting = new List();
  List<PlayerData> teamB_Batting = new List();
  List<BallerData> teamA_Bowling = new List();
  List<BallerData> teamB_Bowling = new List();
  List<BallwiseData> ballwiseDetailsA;
  List<BallwiseData> ballwiseDetailsB;

  //App details internal:
  List<PlayerData> teamBatting;
  static List<BallerData> teamBowling;
  List<BallwiseData> ballwiseDetails = new List();
  TextEditingController noBallController,
      preWicketScoreBallController,
      bowlerIndexController;
  int noBallInputTotal = 0;
  bool undoDisabler = true;
  bool undoClicked = false;
  int tempOnStrike;
  int tempNonStrike;
  int overNumber = 1;
  static MatchScreenState matchScreenState;

  //Match details:
  int inning = 1;
  int onStrike = 0;
  int nonStrike = 1;
  int bowlerIndex = 0;
  int leftInUI = 0; //Will be displayed on the left side of the 2 players always
  int rightInUI =
      1; //Will be displayed on the right side of the 2 players always
  int totalBallsToBePlayed = 36;
  int totalWickets;

  String teamAName = "Team A", teamBName = "Team B";
  int targetGiven;

  //Inning:1
  int ballsA = 0; //Balls played by teamA
  int totalRunsA = 0;
  int totalWicketsA = 0;
  //Inning:2
  int ballsB = 0; //Balls played by teamB
  int totalRunsB = 0;
  int totalWicketsB = 0;

  @override
  void initState() {
    matchScreenState = this;
    //teamBowling = new List();
    teamAName =
        widget.playerNameState.widget.matchDetailsState.tANamecontroller.text;
    teamBName = widget.playerNameState.widget.matchDetailsState.tBNamecontroller
        .text; //Assigning team names
    totalBallsToBePlayed = 6 *
        int.parse(widget.playerNameState.widget.matchDetailsState
            .totalOversController.text); //Conversion of overs to balls
    widget.playerNameState.teamA.forEach((p) {
      teamA_Batting.add(new PlayerData(p, 0, false, 0));
      teamA_Bowling.add(new BallerData(p, 0, 0, 0));
    });
    teamA_Batting.add(new PlayerData("Extras", 0, false, 0));
    widget.playerNameState.teamB.forEach((p) {
      teamB_Batting.add(new PlayerData(p, 0, false, 0));
      teamB_Bowling.add(new BallerData(p, 0, 0, 0));
    }); //Initialising team from other class to this.
    teamB_Batting
        .add(new PlayerData("Extras", 0, false, 0)); //Extras to store wide etc.
    //To switch batting team to 'B' if teamA(By default chosen to bat by me) has not chosen to bat first.
    if (widget.playerNameState.widget.matchDetailsState.groupValue == 2) {
      List<PlayerData> tempAPd = teamA_Batting;
      List<BallerData> tempABd = teamA_Bowling;
      teamA_Batting = teamB_Batting;
      teamA_Bowling = teamB_Bowling;
      teamB_Batting = tempAPd;
      teamB_Bowling = tempABd;
    }

    ballwiseDetails = [
      new BallwiseData(0, 0, 0, false, 0, 0, case_Each_Ball.dot)
    ];
    ballwiseDetailsA = [
      new BallwiseData(0, 0, 0, false, 0, 0, case_Each_Ball.dot)
    ];
    ballwiseDetailsB = [
      new BallwiseData(0, 0, 0, false, 0, 0, case_Each_Ball.dot)
    ];

    if (inning == 1) {
      teamBatting = teamA_Batting;
      teamBowling = teamB_Bowling;
      ballwiseDetails = ballwiseDetailsA;
    } else {
      teamBatting = teamB_Batting;
      teamBowling = teamA_Bowling;
      ballwiseDetails = ballwiseDetailsB;
    } //To set correct team to correct field

    noBallController = new TextEditingController(text: "");
    preWicketScoreBallController = new TextEditingController(text: "");
    bowlerIndexController = new TextEditingController(text: "");

    super.initState();
  }

  void changeBatsman(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new SimpleDialog(
            children: <Widget>[
              new WicketManager(this),
              new Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                child: new RaisedButton(
                  color: Colors.grey[300],
                  child: new Text(
                    "DONE",
                    style: new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      onStrike = tempOnStrike;
                      nonStrike = tempNonStrike;
                      leftInUI = onStrike;
                      rightInUI = nonStrike;
                      changeTotals();
                      Navigator.pop(context);
                    });
                  },
                ),
              )
            ],
          );
        });
  }

  //To change Bowler: ------------------------------------------------------------------------------------------
  void changeBowler(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new SimpleDialog(
            title: new Text("Who is bowling next?",
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            children: <Widget>[
              new Column(
                children: List<Widget>.generate(teamBowling.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.all(2.0),
                          child: new Text(
                            (index + 1).toString(),
                            style: new TextStyle(fontSize: 15.0),
                          ),
                        ),
                        new Text(teamBowling[index].player["Name"],
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  );
                }),
              ),
              new TextFormField(
                keyboardType: new TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                decoration: new InputDecoration(
                    hintText: "Enter the bowler's corresponding number"),
                controller: bowlerIndexController,
              ),
              new RaisedButton(
                  child: new Text(
                    "DONE",
                    style: new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    int a =
                        int.parse(bowlerIndexController.text.toString());
                    a--;                        
                    if (a >= 0 && a < teamBowling.length) {
                      bowlerIndex = a;
                      Navigator.pop(context);
                    }
                  })
            ],
          );
        });
  }

  //To change total data of tournament: ------------------------------------------------------------------------
  void changeTotals() {
    setState(() {
      //For changing strike and bowler
      if (inning == 1) {
        totalRunsA = 0;
        totalWicketsA = 0;
        teamA_Batting.forEach((p) {
          totalRunsA += p.player["Runs"]; //For total runs
          (p.player["Out"] == true)
              ? totalWicketsA += 1
              : null; //For total wickets
        });
        ballsB = 0;
        teamB_Bowling.forEach((p) {
          ballsB += p.player["Balls"]; //For total Balls
        });
      } else {
        totalRunsB = 0;
        totalWicketsB = 0;
        teamB_Batting.forEach((p) {
          totalRunsB += p.player["Runs"]; //For total runs
          (p.player["Out"] == true)
              ? totalWicketsB += 1
              : null; //For total wickets
        });
        ballsA = 0;
        teamA_Bowling.forEach((p) {
          ballsA += p.player["Balls"]; //For total Balls
        });
      }
      print("totalWickets " +
          totalWickets.toString() +
          "totalWicketsA " +
          totalWicketsA.toString() +
          "totalWicketsB " +
          totalWicketsB.toString());
      if (((ballsB % 6 == 0 && ballsB != 0) ||
              (ballsA % 6 == 0 && ballsA != 0)) &&
          undoClicked == false) {
        changeBowler(context);
        int temp = onStrike;
        onStrike = nonStrike;
        nonStrike = temp;
      }
    });
  }

  //noBall:-----------------------------------------------------------------------------------------------------
  void noBall(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new SimpleDialog(
            title: new Text(
                "Total score including No Ball and Freehit, excluding penalty:",
                style: new TextStyle(fontSize: 15.0)),
            children: <Widget>[
              new Container(
                  padding: new EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                  child: new TextField(
                    keyboardType: new TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    decoration: new InputDecoration(
                        fillColor: Colors.blueGrey[900],
                        border: new UnderlineInputBorder()),
                    textAlign: TextAlign.center,
                    maxLength: 2,
                    controller: noBallController,
                    style: new TextStyle(color: Colors.black, fontSize: 15.0),
                  )),
              new Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                child: new RaisedButton(
                  color: Colors.grey[300],
                  child: new Text(
                    "DONE",
                    style: new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      noBallInputTotal =
                          int.parse(noBallController.text.toString());
                      teamBatting[onStrike].player["Balls"] += 1;
                      teamBatting[teamBatting.length - 1].player["Runs"] += 1;

                      teamBowling[bowlerIndex].player["Balls"] += 1;
                      teamBatting[onStrike].player["Runs"] += noBallInputTotal;
                      teamBowling[bowlerIndex].player["Runs"] +=
                          noBallInputTotal;

                      ballwiseDetails.add(new BallwiseData(
                          onStrike,
                          nonStrike,
                          bowlerIndex,
                          false,
                          noBallInputTotal,
                          1,
                          case_Each_Ball.NB));
                      changeTotals();
                      Navigator.pop(context);
                    });
                  },
                ),
              )
            ],
          );
        });
  }

  //For undo:---------------------------------------------------------------------------------------------------
  void undo() {
    int x = ballwiseDetails.length - 1;
    if (x >= 0) {
      teamBatting[onStrike].player["Out"] = false;
      teamBatting[nonStrike].player["Out"] = false;
      if (ballwiseDetails[x].ball["OutBool"]) {
        if (leftInUI == onStrike) {
          onStrike = ballwiseDetails[x].ball["OnStrikeIndex"];
          nonStrike = ballwiseDetails[x].ball["NonStrikeIndex"];
          leftInUI = onStrike;
          rightInUI = nonStrike;
        } else if (rightInUI == onStrike) {
          onStrike = ballwiseDetails[x].ball["OnStrikeIndex"];
          nonStrike = ballwiseDetails[x].ball["NonStrikeIndex"];
          rightInUI = onStrike;
          leftInUI = nonStrike;
        }
      } else {
        onStrike = ballwiseDetails[x].ball["OnStrikeIndex"];
        nonStrike = ballwiseDetails[x].ball["NonStrikeIndex"];
      }

      bowlerIndex = ballwiseDetails[x].ball["BowlerIndex"];
      teamBowling[bowlerIndex].player["Runs"] -=
          ballwiseDetails[x].ball["Runs"];
      // For Wide
      if (ballwiseDetails[x].ball["TypeOfBall"] == case_Each_Ball.WD ||
          ballwiseDetails[x].ball["TypeOfBall"] == case_Each_Ball.WD4) {
        teamBatting[teamBatting.length - 1].player["Runs"] -=
            ballwiseDetails[x].ball["Runs"];
      } else if (ballwiseDetails[x].ball["TypeOfBall"] == case_Each_Ball.NB) {
        teamBatting[teamBatting.length - 1].player["Runs"] -= 1;
        teamBatting[onStrike].player["Runs"] -= ballwiseDetails[x].ball["Runs"];
      } else {
        teamBatting[onStrike].player["Runs"] -= ballwiseDetails[x].ball["Runs"];
      }

      teamBatting[onStrike].player["Balls"] -=
          ballwiseDetails[x].ball["BallsConsumed"];

      teamBowling[bowlerIndex].player["Balls"] -=
          ballwiseDetails[x].ball["BallsConsumed"];
      teamBowling[bowlerIndex].player["Wickets"] -=
          (ballwiseDetails[x].ball["OutBool"]) ? 1 : 0;
      teamBatting[onStrike].player["Out"] = false;
      teamBatting[nonStrike].player["Out"] = false;
      ballwiseDetails.removeAt(x);
    }
    changeTotals();
  }

  //Change entire data per ball: -------------------------------------------------------------------------------
  void changeData(case_Each_Ball c) {
    setState(() {
      undoClicked = false;
      switch (c) {
        case case_Each_Ball.dot:
          teamBatting[onStrike].player["Balls"] += 1;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 0, 1, case_Each_Ball.OUT));
          break;
        case case_Each_Ball.Singles:
          teamBatting[onStrike].player["Runs"] += 1;
          teamBatting[onStrike].player["Balls"] += 1;
          teamBowling[bowlerIndex].player["Runs"] += 1;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 1, 1, case_Each_Ball.Singles));
          int temp = onStrike;
          onStrike = nonStrike;
          nonStrike = temp;
          break;
        case case_Each_Ball.Doubles:
          teamBatting[onStrike].player["Runs"] += 2;
          teamBatting[onStrike].player["Balls"] += 1;
          teamBowling[bowlerIndex].player["Runs"] += 2;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 2, 1, case_Each_Ball.Doubles));
          break;
        case case_Each_Ball.Triples:
          teamBatting[onStrike].player["Runs"] += 3;
          teamBatting[onStrike].player["Balls"] += 1;
          teamBowling[bowlerIndex].player["Runs"] += 3;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 3, 1, case_Each_Ball.Triples));
          int temp = onStrike;
          onStrike = nonStrike;
          nonStrike = temp;
          break;
        case case_Each_Ball.Four:
          teamBatting[onStrike].player["Runs"] += 4;
          teamBatting[onStrike].player["Balls"] += 1;
          teamBowling[bowlerIndex].player["Runs"] += 4;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 4, 1, case_Each_Ball.Four));
          break;
        case case_Each_Ball.Six:
          teamBatting[onStrike].player["Runs"] += 6;
          teamBatting[onStrike].player["Balls"] += 1;
          teamBowling[bowlerIndex].player["Runs"] += 6;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 6, 1, case_Each_Ball.Six));
          break;
        case case_Each_Ball.WD:
          teamBatting[teamBatting.length - 1].player["Runs"] += 1;
          teamBowling[bowlerIndex].player["Balls"] -=
              1; //To nullify the addition done down.
          teamBowling[bowlerIndex].player["Runs"] += 1;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 1, 0, case_Each_Ball.WD));
          break;
        case case_Each_Ball.WD4:
          teamBatting[teamBatting.length - 1].player["Runs"] += 5;
          teamBowling[bowlerIndex].player["Balls"] -=
              1; //To nullify the addition done down.
          teamBowling[bowlerIndex].player["Runs"] += 5;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 5, 0, case_Each_Ball.WD4));
          break;
        case case_Each_Ball.Five:
          teamBatting[onStrike].player["Runs"] += 5;
          teamBatting[onStrike].player["Balls"] += 1;
          teamBowling[bowlerIndex].player["Runs"] += 5;
          ballwiseDetails.add(new BallwiseData(onStrike, nonStrike, bowlerIndex,
              false, 5, 1, case_Each_Ball.Five));
          int temp = onStrike;
          onStrike = nonStrike;
          nonStrike = temp;
          break;
        case case_Each_Ball.OUT:
          out(context);
          teamBowling[bowlerIndex].player["Balls"] -= 1;
          break;
        case case_Each_Ball.NB:
          noBall(context);
          teamBowling[bowlerIndex].player["Balls"] -= 1;
          break;
        case case_Each_Ball.undo:
          teamBowling[bowlerIndex].player["Balls"] -= 1;
          undoClicked = true;
          undo();
          break;
        default:
          return;
      }
      teamBowling[bowlerIndex].player["Balls"] += 1;
      changeTotals();
      undoDisabler = ((inning == 1 && ballsB == 0 && totalRunsA == 0) ||
              (inning == 2 && ballsA == 0 && totalRunsB == 0))
          ? true
          : false;
    });
  }

  //For OUT:----------------------------------------------------------------------------------------------------
  void out(BuildContext context) {
    tempNonStrike = nonStrike;
    tempOnStrike = onStrike;
    int preWicketRun = 0;
    (teamBatting.length - 2 == totalWickets)
        ? (showDialog(
            context: context,
            builder: (context) {
              return new SimpleDialog(
                  title: new Text("Give required information",
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 12.0),
                      child: new TextField(
                        keyboardType: new TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        decoration: new InputDecoration(
                            hintText: "Runs scored before the wicket",
                            hintStyle: new TextStyle(color: Colors.grey)),
                        controller: preWicketScoreBallController,
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                      child: new RaisedButton(
                        color: Colors.grey[300],
                        child: new Text(
                          "DONE",
                          style: new TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            preWicketRun = int.parse(
                                preWicketScoreBallController.text.toString());
                            teamBatting[onStrike].player["Runs"] +=
                                preWicketRun;
                            teamBowling[bowlerIndex].player["Runs"] +=
                                preWicketRun;
                            teamBatting[onStrike].player["Out"] = true;
                            teamBatting[onStrike].player["Balls"] += 1;
                            ballwiseDetails.add(new BallwiseData(
                                onStrike,
                                nonStrike,
                                bowlerIndex,
                                true,
                                preWicketRun,
                                1,
                                case_Each_Ball.OUT));
                            teamBowling[bowlerIndex].player["Balls"] += 1;
                            teamBowling[bowlerIndex].player["Wickets"] += 1;
                            changeData(case_Each_Ball.dot);
                            undo();
                            changeTotals();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    )
                  ]);
            }))
        : showDialog(
            context: context,
            builder: (context) {
              return new SimpleDialog(
                  title: new Text("Give required information",
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 12.0),
                      child: new TextField(
                        keyboardType: new TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        decoration: new InputDecoration(
                            hintText: "Runs scored before the wicket",
                            hintStyle: new TextStyle(color: Colors.grey)),
                        controller: preWicketScoreBallController,
                      ),
                    ),
                    new WicketManager(this),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                      child: new RaisedButton(
                        color: Colors.grey[300],
                        child: new Text(
                          "DONE",
                          style: new TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            preWicketRun = int.parse(
                                preWicketScoreBallController.text.toString());
                            teamBatting[onStrike].player["Runs"] +=
                                preWicketRun;
                            teamBowling[bowlerIndex].player["Runs"] +=
                                preWicketRun;
                            teamBatting[onStrike].player["Balls"] += 1;
                            ballwiseDetails.add(new BallwiseData(
                                onStrike,
                                nonStrike,
                                bowlerIndex,
                                true,
                                preWicketRun,
                                1,
                                case_Each_Ball.OUT));
                            if (totalWickets == (teamBatting.length - 3)) {
                              onStrike = tempOnStrike;
                              nonStrike = tempOnStrike;
                              teamBatting.forEach((f) {
                                (f.player["Out"] == false &&
                                        f.player["Name"] != "Extras" &&
                                        f.player["Name"] !=
                                            teamBatting[onStrike]
                                                .player["Name"])
                                    ? (f.player["Out"] = true)
                                    : null;
                              });
                            } else {
                              if ((nonStrike == tempNonStrike ||
                                  nonStrike == tempOnStrike)) {
                                teamBatting[onStrike].player["Out"] = true;
                              } else if ((onStrike == tempNonStrike ||
                                  onStrike == tempOnStrike)) {
                                teamBatting[nonStrike].player["Out"] = true;
                              }
                              onStrike = tempOnStrike;
                              nonStrike = tempNonStrike;
                              leftInUI = onStrike;
                              rightInUI = nonStrike;
                            }
                            print("Temp onStrike:" +
                                tempOnStrike.toString() +
                                "Temp nonStrike:" +
                                tempNonStrike.toString() +
                                "onStrike:" +
                                onStrike.toString() +
                                "nonStrike" +
                                nonStrike.toString());
                            teamBowling[bowlerIndex].player["Balls"] += 1;
                            teamBowling[bowlerIndex].player["Wickets"] += 1;
                            changeTotals();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    )
                  ]);
            });
  }

  //Change innings:
  void changeInnings() {
    if (inning == 1 &&
        (totalWickets == teamA_Batting.length - 2 ||
            ballsA == totalBallsToBePlayed)) {
      //Change innings
      setState(() {
        inning = 2;
        ballwiseDetailsA = ballwiseDetails;
        //#Initiate ecverything:
        onStrike = 0;
        nonStrike = 1;
        leftInUI = onStrike;
        rightInUI = nonStrike;
        bowlerIndex = 0;
        totalWickets = totalWicketsB;
        targetGiven = totalRunsA;
        ballwiseDetails = ballwiseDetailsB;
        changeTotals();
        //#Show SnackBar stating innings 2 has started
      });
    }
  }

  //Return icon for each ball:----------------------------------------------------------------------------------
  Container getIcon(case_Each_Ball ib) {
    String text = "O";
    switch (ib) {
      case case_Each_Ball.dot:
        text = "O";
        break;
      case case_Each_Ball.Singles:
        text = "1";
        break;
      case case_Each_Ball.Doubles:
        text = "2";
        break;
      case case_Each_Ball.Triples:
        text = "3";
        break;
      case case_Each_Ball.Four:
        text = "4";
        break;
      case case_Each_Ball.Six:
        text = "6";
        break;
      case case_Each_Ball.WD:
        text = "WD";
        break;
      case case_Each_Ball.WD4:
        text = "4WD";
        break;
      case case_Each_Ball.Five:
        text = "5";
        break;
      case case_Each_Ball.OUT:
        text = "OUT";
        break;
      case case_Each_Ball.NB:
        text = "NB";
        break;
      default:
    }
    return new Container(
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: (ib == case_Each_Ball.OUT)
              ? Colors.red[800]
              : Colors.yellow[800]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (inning == 1) {
      teamBatting = teamA_Batting;
      teamBowling = teamB_Bowling;
    } else {
      teamBatting = teamB_Batting;
      teamBowling = teamA_Bowling;
    } //To set correct team to correct field
    //changeTotals();

    totalWickets = (inning == 1) ? totalWicketsA : totalWicketsB;
    //To check Winning:
    void checkWinning() {
      print("checkWinnerMethod: " +
          "totalWickets " +
          totalWickets.toString() +
          "totalWicketsA " +
          totalWicketsA.toString() +
          "totalWicketsB " +
          totalWicketsB.toString());
      if (inning == 2 &&
          (totalWicketsB == teamB_Batting.length - 1 ||
              totalRunsB >= targetGiven - 1 ||
              ballsB == totalBallsToBePlayed)) {
        //Check winner or Tie.
        if (totalRunsB >= targetGiven) {
          //B won
          print("Showing Winning screen!");
        } else if ((totalWicketsB == teamB_Batting.length - 1 ||
                ballsB == totalBallsToBePlayed) &&
            totalRunsB != targetGiven) {
          print("Showing Winning screen!");
        } else if (totalRunsB == targetGiven - 1) {
          print("Showing Winning screen!");
        }
      }
    }

    checkWinning();

    //----------------------------------------------------------------------------------------------------------------
    Widget matchDetails = new Container(
        color: Colors.blueGrey[900],
        child: new Column(children: <Widget>[
          new Container(
              //Score
              padding: new EdgeInsets.fromLTRB(0.0, 14.0, 8.0, 8.0),
              child: new Text(
                  (inning == 1
                          ? totalRunsA.toString()
                          : totalRunsB.toString()) +
                      "-" +
                      (inning == 1
                          ? totalWicketsA.toString()
                          : totalWicketsB.toString()),
                  style: new TextStyle(
                    fontSize: 48.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))),
          new Container(
              //RR,...etc
              padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: new Text(
                              "Total Overs: " +
                                  (totalBallsToBePlayed / 6).round().toString(),
                              style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: new Text(
                            inning == 1
                                ? "Inning: 1"
                                : ("Target: " + targetGiven.toString()),
                            style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: new Text(
                            inning == 1
                                ? ("Req run rate: -")
                                : ("Req run rate: ${((targetGiven-totalRunsB)/((totalBallsToBePlayed-ballsB)/6)).ceil()}"),
                            style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: new Text(
                            (inning == 1
                                ? "Run Rate: " +
                                    ((totalRunsA /
                                                ((ballsB <= 0) ? 1 : ballsB)) *
                                            6)
                                        .toStringAsFixed(2)
                                : "Run Rate: " +
                                    ((totalRunsB /
                                                ((ballsA <= 0) ? 1 : ballsA)) *
                                            6)
                                        .toStringAsFixed(2)),
                            style: new TextStyle(
                              fontSize: 18.0,
                              color: (inning == 1)
                                  ? Colors.white
                                  : ((((targetGiven - totalRunsB) /
                                              ((totalBallsToBePlayed - ballsB) /
                                                  6))) <=
                                          ((totalRunsB /
                                                  ((ballsA <= 0)
                                                      ? 1
                                                      : ballsA)) *
                                              6))
                                      ? (Colors.cyan[700])
                                      : Colors.red[800],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: new Text(
                          (inning == 2)
                              ? ("Need ${targetGiven-totalRunsB} for ${totalBallsToBePlayed-ballsB}")
                              : ("Balls remaining: ${totalBallsToBePlayed-ballsB}"),
                          style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: new Text(
                            (inning == 1
                                ? "Expected Traget: " +
                                    (((totalBallsToBePlayed / 6) *
                                                ((totalRunsA /
                                                        ((ballsB <= 0)
                                                            ? 1
                                                            : ballsB)) *
                                                    6))
                                            .round())
                                        .toString()
                                : "Expected: " +
                                    (((totalBallsToBePlayed / 6) *
                                                ((totalRunsB /
                                                        ((ballsA <= 0)
                                                            ? 1
                                                            : ballsA)) *
                                                    6))
                                            .round())
                                        .toString()),
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.white)),
                      ),
                    ],
                  )
                ],
              )),
          new Container(
              //Each Player Data:
              decoration: new BoxDecoration(
                  border: new Border(
                      top: new BorderSide(color: Colors.grey, width: 0.5))),
              child: (teamBatting.length - 2 - totalWickets == 0)
                  ? (new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                          new Container(
                              padding:
                                  new EdgeInsets.fromLTRB(2.0, 6.0, 0.0, 8.0),
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Padding(
                                        padding: new EdgeInsetsDirectional.only(
                                            bottom: 4.0),
                                        child: new Container(
                                            child: new Row(children: <Widget>[
                                          (new Icon(Icons.arrow_right,
                                              color: Colors.yellow[800])),
                                          new Text(
                                              teamBatting[onStrike]
                                                      .player["Name"] +
                                                  ":",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0))
                                        ]))),
                                    new Text(
                                      "   " +
                                          teamBatting[onStrike]
                                              .player["Runs"]
                                              .toString() +
                                          "-" +
                                          teamBatting[onStrike]
                                              .player["Balls"]
                                              .toString(),
                                      style: new TextStyle(color: Colors.white),
                                    )
                                  ])),
                        ]))
                  : new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                          new Container(
                              padding:
                                  new EdgeInsets.fromLTRB(2.0, 6.0, 0.0, 8.0),
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Padding(
                                        padding: new EdgeInsetsDirectional.only(
                                            bottom: 4.0),
                                        child: new Container(
                                            child: new Row(children: <Widget>[
                                          (leftInUI == onStrike ||
                                                  (rightInUI >=
                                                          (teamBatting.length -
                                                              2) &&
                                                      teamBatting[rightInUI]
                                                              .player["Out"] ==
                                                          true))
                                              ? (new Icon(Icons.arrow_right,
                                                  color: Colors.yellow[800]))
                                              : (new Icon(Icons.arrow_right,
                                                  color: Colors.blueGrey[900])),
                                          new Text(
                                              teamBatting[leftInUI]
                                                      .player["Name"] +
                                                  ":",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0))
                                        ]))),
                                    new Text(
                                      "   " +
                                          teamBatting[leftInUI]
                                              .player["Runs"]
                                              .toString() +
                                          "-" +
                                          teamBatting[leftInUI]
                                              .player["Balls"]
                                              .toString(),
                                      style: new TextStyle(color: Colors.white),
                                    )
                                  ])),
                          new Container(
                              padding:
                                  new EdgeInsets.fromLTRB(2.0, 6.0, 0.0, 8.0),
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Padding(
                                        padding: new EdgeInsetsDirectional.only(
                                            bottom: 4.0),
                                        child: Container(
                                            child: new Row(children: <Widget>[
                                          (rightInUI == onStrike ||
                                                  (leftInUI >=
                                                          (teamBatting.length -
                                                              2) &&
                                                      teamBatting[leftInUI]
                                                              .player["Out"] ==
                                                          true))
                                              ? (new Icon(Icons.arrow_right,
                                                  color: Colors.yellow[800]))
                                              : (new Icon(Icons.arrow_right,
                                                  color: Colors.blueGrey[900])),
                                          new Text(
                                              teamBatting[rightInUI]
                                                      .player["Name"] +
                                                  ":",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0))
                                        ]))),
                                    new Text(
                                        "   " +
                                            teamBatting[rightInUI]
                                                .player["Runs"]
                                                .toString() +
                                            "-" +
                                            teamBatting[rightInUI]
                                                .player["Balls"]
                                                .toString(),
                                        style:
                                            new TextStyle(color: Colors.white))
                                  ])),
                        ]))
        ]));

    //Flat(FLexible) Button returner: ------------------------------------------------------------------------------------------
    Flexible scoreButtons(String s, Color mColor, case_Each_Ball c) {
      return new Flexible(
          child: new FlatButton(
        color: Colors.grey[900],
        padding: new EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        disabledColor: Colors.grey[800],
        child: new Text(
          s,
          style: new TextStyle(
              color: mColor, fontFamily: "Roboto", fontSize: 16.0),
        ),
        onPressed: (s == "undo" && undoDisabler == true)
            ? null
            : () {
                changeData(c);
              },
      ));
    }

    //Over Details:----------------------------------------------------------------------------------------------------------
    Widget overDetails = new Container(
      color: Colors.grey[100],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              padding: new EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
              child: new Row(children: <Widget>[
                new Text(
                    teamBowling[bowlerIndex].player["Name"] +
                        " (" +
                        teamBowling[bowlerIndex].player["Wickets"].toString() +
                        ")"
                        ": ",
                    style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                        color: Colors.grey[900])),
                new Text(
                    " " +
                        (inning == 1
                            ? ((ballsB / 6).floorToDouble() + (ballsB % 6) / 10)
                                .toString()
                            : ((ballsA / 6).floorToDouble() + (ballsA % 6) / 10)
                                .toString()),
                    style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                        color: Colors.grey[900])),
                new Flexible(
                  child: new Container(),
                ),
                (inning == 1)
                    ? (new FlatButton(
                        child: new Text("Begin next innings>",
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.black87)),
                        onPressed: () {
                          changeInnings();
                        },
                      ))
                    : new Container(),
              ])),
          new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 19.0, 0.0, 19.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                  (ballwiseDetails.length==0)?(List<Widget>.generate(6,(index) {
                    setState(() {
                      return new Icon(Icons.add);
                    });
                  })):
                      List<Widget>.generate(ballwiseDetails.length,(index) {
                    setState(() {
                      (index >= (6 * (overNumber - 1)))
                          ? (getIcon(ballwiseDetails[index].ball["TypeOfBall"])):null;
                    });
                  }) 
                  /* <Widget>[
                    getIcon(case_Each_Ball.dot),
                    getIcon(case_Each_Ball.dot),
                    getIcon(case_Each_Ball.dot),
                    getIcon(case_Each_Ball.dot),
                  ] */
                  ))
        ],
      ),
    ); //Container

    //Gridmain:------------------------------------------------------------------------------------------------------------
    Widget gridMain = new Flexible(
        child: new Container(
            color: Colors.grey[900],
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Flexible(
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                      scoreButtons("dot", Colors.white, case_Each_Ball.dot),
                      scoreButtons(
                          "Singles", Colors.white, case_Each_Ball.Singles),
                      scoreButtons(
                          "Doubles", Colors.white, case_Each_Ball.Doubles),
                      scoreButtons("OUT", Colors.red[800], case_Each_Ball.OUT),
                    ])),
                new Flexible(
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                      scoreButtons(
                          "Triples", Colors.white, case_Each_Ball.Triples),
                      scoreButtons("Four", Colors.white, case_Each_Ball.Four),
                      scoreButtons("Six", Colors.white, case_Each_Ball.Six),
                      scoreButtons("NB", Colors.yellow[800], case_Each_Ball.NB),
                    ])),
                new Flexible(
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                      scoreButtons(" WD ", Colors.white, case_Each_Ball.WD),
                      scoreButtons(" 4WD ", Colors.white, case_Each_Ball.WD4),
                      scoreButtons("Five", Colors.white, case_Each_Ball.Five),
                      scoreButtons(
                          "undo", Colors.cyan[700], case_Each_Ball.undo)
                    ]))
              ],
            ))); //Container

    // TODO: implement build-------------------------------------------------------------------------------------------
    return new Scaffold(
      appBar: new AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: new Icon(Icons.edit),
            )
          ],
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                teamAName + " - " + teamBName,
                style: new TextStyle(color: Colors.yellow[800], fontSize: 25.0),
              ),
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.blueGrey[900]),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
                child: new Column(
                    children: <Widget>[matchDetails, overDetails, gridMain]))
          ],
        ),
      ),
    );
  }
}
