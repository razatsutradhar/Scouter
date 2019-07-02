class Match {
  String division;
  int matchNum;
  Team blue1;
  Team blue2;
  Team red1;
  Team red2;
  Button r1;
  Button r2;
  Button b1;
  Button b2;
  int round; //1 - practice || 2 - Qualificaction || 3 - Quarter Fin || 4 - Semi Fin || 5 - Final
  int matchImportance;
  int x = 700;
  int y = 100;
  int w = 150;
  int h = 30;
  Match(ArrayList<String[]> arr) {
   division = arr.get(2)[1];
    matchNum = Integer.parseInt(arr.get(5)[1]);
    round = int(arr.get(2)[1]);
    red1 = (Team)myEvent.getMap().get(arr.get(7)[1]);
    red2 = (Team)myEvent.getMap().get(arr.get(8)[1]);

    blue1 = (Team)myEvent.getMap().get(arr.get(11)[1]);
    blue2 = (Team)myEvent.getMap().get(arr.get(12)[1]);

    r1 = new Button(red1.getTeamNumber(), x, y, w, h, color(255, 100, 100));
    r1.setTeam(red1);
    r2 = new Button(red2.getTeamNumber(), x+160, y, w, h, color(255, 100, 100));
    r2.setTeam(red2);
    
    b1 = new Button(blue1.getTeamNumber(), x+(160*2), y, w, h, color(100, 100, 255));
    b1.setTeam(blue1);   
    b2 = new Button(blue2.getTeamNumber(), x+(160*3), y, w, h, color(100, 100, 255));
    b2.setTeam(blue2);
    
    matchImportance = 0;
  }

  void drawMatch() {
    fill(255);
    text("Q"+matchNum, x+(160*2)-10, 50);
    r1.show(true);
    r2.show(true);
    b1.show(true);
    b2.show(true);
  }
  Team getBlue1Team() {
    return blue1;
  }
  Team getRed1Team() {
    return red1;
  }  
  Team getBlue2Team() {
    return blue2;
  }
  Team getRed2Team() {
    return red2;
  }
  int getMatchNum() {
    return matchNum;
  }
  String toString() {
    try {
      return "Q" + matchNum +"\t\t"+red1.getTeamNumber() + " & " + red2.getTeamNumber() + "\tv\t" + blue1.getTeamNumber() + " & " + blue2.getTeamNumber();
    }
    catch(Exception e) {
      return e.toString() + "\t" + e.getCause() + "matches:toString()";
    }
  }

  Team[] getOpponents() {

    if (blue1.getTeamNumber().equals(myTeam.getTeamNumber()) || blue2.getTeamNumber().equals(myTeam.getTeamNumber())) {
      Team[] result = {red1, red2};
      return result;
    } else if (red1.getTeamNumber().equals(myTeam.getTeamNumber()) || red2.getTeamNumber().equals(myTeam.getTeamNumber())) {
      Team[] result = {blue1, blue2};
      return result;
    } else {
      Team[] result = {red1, red2, blue1, blue2};
      return result;
    }
  }
  boolean hasOpponent(Team t) {
    if (red1.getTeamNumber() == t.getTeamNumber()) {
      return true;
    } else if (red2.getTeamNumber() == t.getTeamNumber()) {
      return true;
    } else if (blue1.getTeamNumber() == t.getTeamNumber()) {
      return true;
    } else if (blue2.getTeamNumber() == t.getTeamNumber()) {
      return true;
    }  
    return false;
  }
  void increaseImportance() {
    matchImportance++;
  }
  int getImportance() {
    return matchImportance;
  }
  void setImportance(int imp){
   matchImportance = imp;
   println("Q" + matchNum + " importance set to " + matchImportance);
  }
}
