/* import 'package:flutter/material.dart';
import '../MatchScreen.dart';

class BowlerManager extends StatefulWidget {
  @override
  BowlerManagerState createState() {
    return new BowlerManagerState();
  }
}

class BowlerManagerState extends State<BowlerManager> {
  int groupValue;
  MatchScreenState _matchScreenState;
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: List<Widget>.generate(MatchScreenState.getBallerData.length,
            (index) {
      return new RadioListTile(
          title: new Text(
            MatchScreenState.getBallerData[index].player["Name"],
            style: new TextStyle(color: Colors.blueGrey[700]),
          ),
          activeColor: Colors.blueGrey[700],
          groupValue: groupValue,
          value: index,
          onChanged: (int index) {
            setState(() {
              groupValue = index;
              _matchScreenState.bowlerIndex = groupValue;
            });
          });
    }));
  }
}
 */