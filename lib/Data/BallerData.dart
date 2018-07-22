class BallerData {

  Map<String,dynamic> player = <String,dynamic>{};

  BallerData(String name,int runs,int wickets,int balls){
    player.putIfAbsent("Name", () => name);
    player.putIfAbsent("Runs", () => runs);
    player.putIfAbsent("Wickets", () => wickets);
    player.putIfAbsent("Balls", () => balls);
  }
}