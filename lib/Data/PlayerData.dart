class PlayerData {

  Map<String,dynamic> player = <String,dynamic>{};

  PlayerData(String name,int runs,bool out,int balls){
    player.putIfAbsent("Name", () => name);
    player.putIfAbsent("Runs", () => runs);
    player.putIfAbsent("Out", () => out);
    player.putIfAbsent("Balls", () => balls);
  }
}