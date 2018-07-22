class MatchInfo{
  Map<String,dynamic> info = <String,dynamic>{};

  MatchInfo(String tAName,String tBName,int totalOvers){
       info.putIfAbsent("TeamA_Name", () => tAName);
       info.putIfAbsent("TeamB_Name", () => tBName);
       info.putIfAbsent("TotalOvers", () => totalOvers);
      //info.putIfAbsent("BallwiseDetailsA", () => ballwiseDetailsA);
      //info.putIfAbsent("BallwiseDetailsB", () => ballwiseDetailsB);
  }
}