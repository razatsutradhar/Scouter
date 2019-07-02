class Event {
  String sku;
  String robotEventKey;
  String name;
  ArrayList<String[]> info;
  HashMap<String, Team> allTeams = new HashMap<String, Team>();
  ArrayList<Match> matches = new ArrayList();
  ArrayList<Match> myMatches = new ArrayList();
  ArrayList<Team> allOpponents = new ArrayList();

  Event(ArrayList<String[]> allInfo) {
    sku = allInfo.get(1)[1];
    robotEventKey = allInfo.get(2)[1];
    name = allInfo.get(4)[1];
  }
  String getSKU() {
    return sku;
  }
  void loadInfo() {        //loadInfo loads the information about matches and teams in an event
    allTeams = new HashMap<String, Team>();
    matches = new ArrayList();
    myMatches = new ArrayList();
    allOpponents = new ArrayList();
    readResults(analyze(readURL("https://api.vexdb.io/v1/get_matches?sku="+myEvent.getSKU()+"&team="+myTeam.getTeamNumber())));

    for (ArrayList<String[]> strArr : analyze(readURL("https://api.vexdb.io/v1/get_teams?sku="+sku))) {            //loading in all teams
      if (strArr.size() > 2) {
        Team t = new Team(strArr);
        allTeams.put(t.getTeamNumber(), t);
      }
    }

    matchList.clear();
    for (ArrayList<String[]> strArr : analyze(readURL("https://api.vexdb.io/v1/get_matches?sku="+myEvent.getSKU()+"&team="+myTeam.getTeamNumber()))) {         //loading in my matches
      try {
        Match m = new Match(strArr);
        myMatches.add(m);
        String s = "Q" + m.getMatchNum() +"  |    "+ "R: " + m.getRed1Team().getTeamNumber() + "   " + m.getRed2Team().getTeamNumber();
        String space = "";
        for (int i = s.length(); i < 40; i++) {
          space+=" ";
        }
        matchList.addItem(s + space + "B: " + m.getBlue1Team().getTeamNumber() + "   " + m.getBlue2Team().getTeamNumber(), (Match)m);
      }
      catch(Exception e) {
        println(e + " - event tab, adding my matches" );
      }
    }

    for (ArrayList<String[]> strArr : analyze(readURL("https://api.vexdb.io/v1/get_matches?sku="+myEvent.getSKU()))) {                    //loading in my matches                  
      Match m = new Match(strArr);
      matches.add(m);
    }


    for (Match m : myMatches) {                                                                            //adding my opponents from every match to my opponents list
      for (Team op : m.getOpponents()) {
        allOpponents.add(op);
      }
    }
    println(5);
    createSchedule();
  }


  void drayMyMatches() {
    for (Map.Entry team : allTeams.entrySet()) {
      println("");
    }
  }
  void createSchedule() {                                         //creates the schedule for mataches to go see and record

    for (Match m : myMatches) {                                   //increment the importance of each match    
      for (int i = 0; i < m.getMatchNum()-1; i++) {
        for (Team t : m.getOpponents()) {
          if (matches.get(i).hasOpponent(t)) {
            matches.get(i).increaseImportance();
          }
        }
      }
      if ( matches.get(m.getMatchNum()-1).round < 3)      
        matches.get(m.getMatchNum()-1).setImportance(5);            //setting my matches to high importance
    }
    for (Match m : matches) {
      println(m.getMatchNum() + "\t" + m.getImportance());
    }
  }


  Team getTeam(String teamNumber) {
    try {
      return allTeams.get(teamNumber);
    }
    catch(Exception e) {
      return null;
    }
  }

  String toString() {
    //readResults(analyze(readURL("https://api.vexdb.io/v1/get_teams?sku="+sku)));
    return  "" + allTeams.size();
  }
  HashMap getMap() {
    return allTeams;
  }
  void printMatches() {
    for (Match m : myMatches) {

      println(m.toString());
    }
  }
  String getName() {
    return name;
  }

  void show() {
    if ((millis()/10) % 12000 == 0) {
      loadInfo();
      println("\n\n\nupdate " + (millis()/10));
    }
    matchList.setOpen(true);  

    ((Match)(matchList.getItem((int)matchList.getValue())).get("value")).drawMatch();
  }
  ArrayList<Team> getOpponents() {
    return allOpponents;
  }
}
