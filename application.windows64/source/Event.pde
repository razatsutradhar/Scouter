class Event {
  String sku;
  String robotEventKey;
  String name;
  ArrayList<String[]> info;
  HashMap<String, Team> allTeams = new HashMap<String, Team>();
  ArrayList<Match> matches = new ArrayList();
  ArrayList<Match> myMatches = new ArrayList();
  ArrayList<Team> allOpponents = new ArrayList();
  ArrayList<Integer> scoutScheduleList = new ArrayList();
  ArrayList<ArrayList<Integer>> scoutSchedule;
  boolean isScoutScheduleCreated = false;
  boolean matchesGenerated = false;

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
    scoutScheduleList = new ArrayList();

    for (ArrayList<String[]> strArr : analyze(readURL("https://api.vexdb.io/v1/get_teams?sku="+sku))) {            //loading in all teams
      if (strArr.size() > 2) {
        Team t = new Team(strArr);
        allTeams.put(t.getTeamNumber(), t);
      }
    }

    matchList.clear();
    if (analyze(readURL("https://api.vexdb.io/v1/get_matches?sku="+myEvent.getSKU()+"&team="+myTeam.getTeamNumber())).size() > 5) {
      matchesGenerated = true;
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
        op.setIsOpponent(true);
        allOpponents.add(op);
      }
    }
    }

  }


  void drawMyMatches() {
    for (Map.Entry team : allTeams.entrySet()) {
      println("");
    }
  }
  void createSchedule() {                                          //creates the schedule for mataches to go see and record
    scoutSchedule = new ArrayList();
    scoutScheduleList.clear();
    if (matchesGenerated) {
      for (Match m : myMatches) {                                   //increment the importance of each match    
        m.setImportance(0);
        print("Q:" + m);
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

      for (int i = matches.size()-1; i >= 0; i--) {
        for (Team t : matches.get(i).getAllOpponents()) {
          if (t!=null) {
            if (t.getTimesCovered()<3 && matches.get(i).getImportance() > 0) {
              t.increaseTimesCovered();
            } else if (matches.get(i).getImportance() == 1) {
              matches.get(i).setImportance(0);
            }
          } else {
            println("null team");
          }
        }
      }

      for (Match m : matches) {
        if (m.getImportance() > 0) {
          scoutScheduleList.add(m.getMatchNum());
        }
      }
      println("Schedule size: " + scoutScheduleList.size());
      for (int i : scoutScheduleList) {
        println("q" + i);
      }
    }
    for (int i = 0; i < numOfScouters; i++) {
      ArrayList temp = new ArrayList<Integer>();
      scoutSchedule.add(temp);
    }
    for (int index = 0; index<scoutScheduleList.size(); index++) {
      scoutSchedule.get(index%numOfScouters).add(scoutScheduleList.get(index));
    }
    isScoutScheduleCreated = true;
    print(scoutSchedule);
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
    if (matchesGenerated){
      ((Match)(matchList.getItem((int)matchList.getValue())).get("value")).drawMatch();
    }
    println(isScoutScheduleCreated);
  }
  ArrayList<Team> getOpponents() {
    return allOpponents;
  }
}
