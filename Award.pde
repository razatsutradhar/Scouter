//update check
class Award {
  private String name;
  private String teamNumber;
  private String sku;

  Award(ArrayList<String[]> s) {
    for (String[] entry : s) {
      if (entry[0].equals("name")) {
        name = entry[1];
      } else if (entry[0].equals("sku")) {
        sku = entry[1];
      } else if (entry[0].equals("team")) {
        teamNumber = entry[1];
      }
     
    }
    println(getTournamentName() +" - "+ name);
  }
  
  String getTrophyName(){
   return name; 
  }
  
  String getTeamNumber(){
   return teamNumber; 
  }
  
  String getSku(){
   return sku; 
  }
  String getTournamentName(){
    try{
      return analyze(readURL("https://api.vexdb.io/v1/get_events?sku="+sku)).get(0).get(5)[1];
    }catch(Exception e){
      return null;
    }
  }
}
