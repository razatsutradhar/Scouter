class Team {
  boolean status;
  int size;
  String teamNumber;
  String program;
  String teamName;
  String robotName;
  String organization;
  String city;
  String region;
  String country;
  String grade;
  boolean isRegistered;
  ArrayList<ArrayList<String>> info = new ArrayList();
  ArrayList<Award> allAwards = new ArrayList();
  int timesCovered = 0;
  Team(String allInfo) {

    String[] shotgunned = allInfo.replace("\"", "").replace("result:[{", "").split(",");

    ArrayList<ArrayList<String>> info = new ArrayList();

    for (String s : shotgunned) {
      ArrayList<String> entry = new ArrayList();
      String[] newSplit = s.split(":", 2);
      for (String t : newSplit) {
        entry.add(t);
      }
      info.add(entry);
      //println(entry);
    }
    for (ArrayList<String> ent : info) {
      try {
        if (ent.get(0).equals("number")) {
          teamNumber = (String)ent.get(1);
        } else if (ent.get(0).equals("program")) {
          program = (String)ent.get(1);
        } else if (ent.get(0).equals("team_name")) {
          teamName = (String)ent.get(1);
        } else if (ent.get(0).equals("robot_name")) {
          try {
            robotName = (String)ent.get(1);
          }
          catch(Exception e) {
            robotName = "NULL";
          }
        } else if (ent.get(0).equals("organisation")) {
          organization = (String)ent.get(1);
        } else if (ent.get(0).equals("city")) {
          city = (String)ent.get(1);
        } else if (ent.get(0).equals("region")) {
          region = (String)ent.get(1);
        } else if (ent.get(0).equals("country")) {
          country = (String)ent.get(1);
        } else if (ent.get(0).equals("grade")) {
          grade = (String)ent.get(1);
        } else if ((ent.get(0).equals("size"))) {
          size = Integer.parseInt((String)ent.get(1));
        }
      }
      catch(Exception e) {
        println("no team was found");
      }
    }

    //for(ArrayList<String[]> AwardEntry: getAwardText()){
    // allAwards.add(new Award(AwardEntry)); 
    //}

    //getAwards();
  }
  Team(ArrayList<String[]> info) {
    for (String[] s : info) {
      if (s[0].equals("number")) {
        teamNumber = (String)s[1];
      } else if (s[0].equals("program")) {
        program = (String)s[1];
      } else if (s[0].equals("team_name")) {
        teamName = (String)s[1];
      } else if (s[0].equals("robot_name")) {
        try {
          robotName = (String)s[1];
        }
        catch(Exception e) {
          robotName = "NULL";
        }
      } else if (s[0].equals("organisation")) {
        organization = (String)s[1];
      } else if (s[0].equals("city")) {
        city = (String)s[1];
      } else if (s[0].equals("region")) {
        region = (String)s[1];
      } else if (s[0].equals("country")) {
        country = (String)s[1];
      } else if (s[0].equals("grade")) {
        grade = (String)s[1];
      } else if ((s[0].equals("size"))) {
        size = Integer.parseInt((String)s[1]);
      }
    }
  }

  private ArrayList<ArrayList<String[]>> getAwardText() {
    return analyze(readURL("https://api.vexdb.io/v1/get_awards?team="+teamNumber));
  }

  ArrayList<Award> getAllAwards() {
    return allAwards;
  }

  //ArrayList<Award> getAwardsFrom(String season){

  //}
  String getAwards(String season) {
    return "none";
  }
  int getSize() {
    return size;
  }
  String getTeamNumber() {
    return teamNumber;
  }
  String getTeamName() {
    return teamName;
  }
  String getOrganization() {
    return organization;
  }
  String getProgram() {
    return program;
  }
  String toString() {
    return teamNumber;
  }
  int getTimesCovered(){
   return timesCovered;
  }

}
