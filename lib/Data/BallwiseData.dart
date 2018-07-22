class BallwiseData{
  Map<String,dynamic> ball = <String,dynamic>{};

  BallwiseData(int onStrikeIndex, int nonStrikeIndex, int bowlerIndex, bool outBool,int runs, int ballsConsumed, dynamic typeOfBall){
    ball.putIfAbsent("OnStrikeIndex", () => onStrikeIndex);
    ball.putIfAbsent("NonStrikeIndex", () => nonStrikeIndex);
    ball.putIfAbsent("BowlerIndex", () => bowlerIndex);
    ball.putIfAbsent("OutBool", () => outBool);
    ball.putIfAbsent("Runs", () => runs);
    ball.putIfAbsent("BallsConsumed", () => ballsConsumed);
    ball.putIfAbsent("TypeOfBall", () => typeOfBall);
  }
}