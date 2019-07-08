 //<>//
class Methods {
  Methods() {
  }
  void setAsMyTeam() {
    myTeam = searchTeam;
    myTeamTab.rename(myTeam.getTeamNumber());
  }

  void drawMyTeamTab() {
    if (myTeam != null) {
      fill(255);
      text(myTeam.getTeamNumber(), 50, 100);
    }
  }

  void drawSearchTab() {
    line(300, 0, 300, height);
  }
  void setMyEvent(Event e) {

    myEvent = e;
    myEvent.loadInfo();
    search.active = false;
    matches.active = true;


    println("set event");
  }
  void eventSearchButton() {
    ArrayList<ArrayList<String[]>> events;
    String url = "https://api.vexdb.io/v1/get_events?";
    if (getDate() != "") {
      url += "date=" + getDate();
      if (myTeam!=null) {
        url+= "&team="+myTeam.getTeamNumber();
      }
    } else {
      url+= "team="+myTeam.getTeamNumber();
    }
    for (Button e : eventButtons) {
      e.show(false);
    }
    eventButtons.clear();
    events = analyze(readURL(url));
    readResults(events);
    Button b;
    Event comp;
    for (int i = 0; i < (events.size() >15? 15 : events.size()); i++) {
      b = new Button(events.get(i).get(4)[1], 500, 170+(i*35), 750, 25, color(255));
      try {
        Class[] parameterTypes = new Class[1];
        parameterTypes[0] = Event.class;
        b.setMethod(Methods.class.getMethod("setMyEvent", parameterTypes));
      }
      catch(Exception e) {
        println(e + " could not get event");
      }
      //b.setButtonEvent(new Event(events.get(i)));
      try {
        println(events.get(i).get(4)[1]);
        comp = new Event(analyze(readURL(url)).get(i));
      }
      catch(Exception e) {
        comp = null;
        println(e + "setting competition event method - eventSearchButton");
      }
      try {
        b.setButtonEvent(comp);
      }
      catch(Exception e) {
        println(e.getCause() + " could not set");
      }
      eventButtons.add(b);
      println("event button added");
    }
  }
  void createAnEvent() {
    println("creating an event");
    creatingAnEvent = true;
  }
  void selectEvent() {
    if (!isFileSelectorOpen) {
      isFileSelectorOpen = true;
      try {
        selectFolder("Locate Schedule", "folderSelected", new File("../"));
      }
      catch(Exception e) {
        println(e + " - selectEvent from file");
        isFileSelectorOpen = false;
      }
    }
    doesEventExist = false;
  }
  void selectExistingEvent() {
    doesEventExist = false;
  }
  void createDuplicateEvent() {
    File dir = new File("./", myEvent.getName()+"-Duplicate");
    dir.mkdir();
    PrintWriter writer = createWriter(dir+"/eventDetail.txt");
    writer.println("sku : "+myEvent.getSKU());
    writer.println("name : " + myEvent.getName());
    writer.println("team : " + myTeam.getTeamNumber());
    writer.flush();
    writer.close();
    doesEventExist = false;
    eventSelected = true;
  }

  void showSelectedMatch() {
  }

  void teamSelected(Object o) {
    println(((Team)o).getTeamName());
  }

  void createScoutingSchedule() {
    myEvent.createSchedule(); 
    if (myEvent.scoutScheduleList.size()>0) {
      loadScheduleButton.setColor(color(0, 255, 55));
    } else {
      loadScheduleButton.setColor(color(255, 55, 0));
    }
  }

  void increaseScouterNumber() {
    if (numOfScouters<5) {
      numOfScouters++; 
      displayNumOfScouter.setText(""+numOfScouters);
    }
  }
  void decreaseScouterNumber() {
    if (numOfScouters>1) {
      numOfScouters--; 
      displayNumOfScouter.setText(""+numOfScouters);
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////public static methods//////////////////////////////////////////////////////////
/*                                                                                                                                                                */
/*                                                                                                                                                                */
/*                                                                                                                                                                */
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public static String readURL(String s) {
  BufferedReader br = null;
  StringBuilder sb = new StringBuilder();
  try {
    URL url = new URL(s);
    br = new BufferedReader(new InputStreamReader(url.openStream()));
    String line;
    while ((line = br.readLine()) != null) {
      sb.append(line);
      sb.append(System.lineSeparator());
    }
  } 
  catch(Exception e) {
  }
  return sb.toString();
}

public static ArrayList<ArrayList<String[]>> analyze(String s) {

  String finString = s;
  finString = finString.replace("{", "").replace("result\":", "").replace("[", "")
    .replace("\"", "").replace("]", "").replace(" number", "number").trim();
  try {
    finString = finString.substring(finString.indexOf("size"));
  }
  catch(Exception e) {
  }
  ArrayList<ArrayList<String[]>> results = new ArrayList();
  String[] shotgunned = finString.split("}");
  for (String str : shotgunned) {
    ArrayList<String[]> dataEntry = new ArrayList();
    for (String data : str.split(",")) {
      data.trim();
      dataEntry.add(data.split(":"));
    }
    results.add(dataEntry);
  }
  return results;
}

public static void readResults(ArrayList<ArrayList<String[]>> c) {
  for (ArrayList<String[]> d : c) {
    for (String[] e : d) {
      for (String f : e) {
        print(f + " ");
      }
      println();
    }
    println("//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
  }
}
public static String[] readFile(BufferedReader r) {
  ArrayList<String> lines = new ArrayList();
  String currentLine = null;
  try {
    while ((currentLine = r.readLine()) != null) {
      lines.add(currentLine);
    }
  }
  catch(Exception e) {
  }
  String result[] = new String[lines.size()];
  for (int i = 0; i < lines.size(); i++) {
    result[i] = lines.get(i);
  }
  return result;
}
Team getTeam(String teamNumber) {
  return new Team(readURL("https://api.vexdb.io/v1/get_teams?team="+teamNumber));
}

public static void setMethod(Drawable d, String methodName) {
  try {
    d.setMethod(Methods.class.getMethod(methodName));
  }
  catch(Exception e) {
    println("Setting Method Error");
  }
}

public static void setMethod(Drawable d, String methodName, Object o) {
  try {
    d.setMethod(Methods.class.getMethod(methodName));
  }
  catch(Exception e) {
    println("Setting Method Error");
  }
}

public void customizeMonthDDL(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(255));
  ddl.setItemHeight(30);
  ddl.setBarHeight(30);
  ddl.setColorBackground(color(150));
  ddl.setColorActive(color(255, 128));
  ddl.setColorLabel(0);
  ddl.setColorValueLabel(0); 
  ddl.getCaptionLabel().setFont(createFont("Calibri", 20));
  ddl.getValueLabel().setFont(createFont("Calibri", 15));
  ddl.close();
  ddl.addItem("Jan", 1);  
  ddl.addItem("Feb", 2);  
  ddl.addItem("Mar", 3);  
  ddl.addItem("Apr", 4);  
  ddl.addItem("May", 5);  
  ddl.addItem("Jun", 6);
  ddl.addItem("Jul", 7);  
  ddl.addItem("Aug", 8);  
  ddl.addItem("Sep", 9);  
  ddl.addItem("Oct", 10); 
  ddl.addItem("Nov", 11); 
  ddl.addItem("Dec", 12);
}

public void customizeNumberDDL(DropdownList ddl, int start, int end) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(255));
  ddl.setItemHeight(30);
  ddl.setBarHeight(30);
  ddl.setColorBackground(color(150));
  ddl.setColorActive(color(255, 128));
  ddl.setColorLabel(0);
  ddl.setColorValueLabel(0); 
  ddl.getCaptionLabel().setFont(createFont("Calibri", 20));
  ddl.getValueLabel().setFont(createFont("Calibri", 15));
  ddl.close();

  for (int i = start; i < end+1; i++) {
    ddl.addItem(""+i, i);
  }
}

public static void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
  theEvent.getController().setId(1);
}

public void folderSelected(File selection) {
  boolean areThereDetails = false;

  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    matchSchedulePath = selection.getAbsolutePath();


    for (File f : selection.listFiles()) {
      if (f.getName().equals("eventDetail.txt")) {
        areThereDetails = true;
      }
    }
    if (areThereDetails) {
      try {
        BufferedReader reader = createReader(selection+"/eventDetail.txt");
        String[] lines = readFile(reader);
        myEvent = new Event(analyze(readURL("https://api.vexdb.io/v1/get_events?sku="+lines[0].replace("sku : ", ""))).get(0));   
        myTeam = getTeam(lines[2].replace("team : ", ""));
        myEvent.loadInfo();
        println("User selected " + myEvent.getName() + " as team " + myTeam.getTeamNumber());
        eventSelected = true;
      }  
      catch(Exception e) {
        println(e + " folderSelected method");
        methodBank.selectEvent();
      }
    } else {
      println("no details found");
    }
  }
  isFileSelectorOpen = false;
  mousePressed = false;
}
public static String twoDigit(int i) {
  if (i<10) {
    return "0"+i;
  } else {
    return  ""+i;
  }
}

public static String getDate() {
  String result = "";

  if (yearDDL.getId() == 1) {
    result = ""+yearDDL.getItem((int)yearDDL.getValue()).get("value");   
    if (monthDDL.getId() != -1) {
      result += "-"+twoDigit(Integer.parseInt((String)monthDDL.getItem((int)monthDDL.getValue()).get("value").toString()));
      if (dateDDL.getId() != -1) {
        result += "-" + twoDigit(Integer.parseInt((String)dateDDL.getItem((int)dateDDL.getValue()).get("value").toString()));
      }
    }
  }

  return result;
}
//void scheduleSelected(File selection) {
//  scheduleAbsolutePath = selection.getAbsolutePath();
//  try {
//    schedule = loadTable(scheduleAbsolutePath); 
//    println("loaded");

//    print(schedule.getString(0, 3) + "\t");
//    print(schedule.getString(0, 4) + "\t");
//    print(schedule.getString(0, 8) + "\t");
//    print(schedule.getString(0, 9) + "\t\n");
//    for (int i = 1; i < schedule.getRowCount(); i ++) {
//      print(schedule.getString(i, 3) + "\t\t");
//      print(schedule.getString(i, 4) + "\t\t");
//      print(schedule.getString(i, 8) + "\t\t");
//      print(schedule.getString(i, 9) + "\t\t");
//      println();
//    }
//  }
//  catch(Exception e) {
//    println(e + " schedule selected method");
//  }
//}
