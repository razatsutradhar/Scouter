import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.net.*; 
import java.io.*; 
import java.lang.reflect.Method; 
import controlP5.*; 
import java.util.*; 
import javax.*; 
import java.lang.reflect.Method; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Scouter extends PApplet {

///////////////////////////////////////////////////////////////////
/*                    Scouter Main                               */ 
/*This class houses all the void draw and setup function which   */
/*braches out and works with all the other classes. This is the  */ 
/*central hub of this entire app                                 */
///////////////////////////////////////////////////////////////////









boolean messageSent;

PImage icon; 
static String matchSchedulePath;
//array that holds all the 
ArrayList<Tab> allTabs;              

//array of all button objects
ArrayList<Button> allButtons;  

//search bar that you type your team name into, found under search tab      
SearchBar teamSearch;         

//if a team is found from team search, this shows information on that team
TextBox teamStats;                 

//the team object of the team found from the search query in search tab
static Team searchTeam;           

//global varaiable for my team. Can be set in the search tab
static Team myTeam;     

//button displayed after a valid team is found from a search query.
//Will set that team to "myTeam"
Button setMyTeam;               

//first tab, labeled "search", used to loacte you team and the event
Tab search;                      

//class for imported GUI
static ControlP5 cp5;         

//class to hold all public static method and to pass methods as 
//a variable (read more in Methods)
Methods methodBank;                  

//use entered date to search for events on that day
Button eventSearch;         

//All tabs
Tab myTeamTab;
Tab matches;
Tab scheduleTab;

//list that will house all buttons for events a team attends
ArrayList<Button> eventButtons;

//Event object that houses the event your team is currently in 
Event myEvent;

//all special button objects
Button locateEvent;
Button createEvent;
Button createDuplicateEvent;
Button openSearchedEvent;
Button loadScheduleButton;
Button addAScouter;
Button removeAScouter;
Button locateAScouter;

//boolean (true false variables)
boolean isFileSelectorOpen = false;
boolean creatingAnEvent = false;
boolean eventSelected = false;
String scheduleAbsolutePath;
String eventFolderPath;
boolean doesEventExist = false;

//Objects to display my matches
ListBox matchList;

//integer that represents scouters
//and display that number
int numOfScouters = 1;
TextBox displayNumOfScouter;

//varaibles and objects in the Dock Tab
ListBox availableMediaList;
public ArrayList<File> currentFiles;
File currentLocation = new File("./");
ArrayList<Scout> allScouts = new ArrayList();


///////////////////////////////////////////////////////////////////
/*                    SETUP FUNCTION                             */ 
/*This function is in the Main Scouter class and runs once at the*/
/*beginning of the code. The purpose of this function is to      */ 
/*initialize all variables and objects                           */
///////////////////////////////////////////////////////////////////
public void setup() {
                     //size of the window
  icon = loadImage("logopng.png");
  icon.resize(564, 564);
  surface.setIcon(icon);
  
  //Arraylist of all tabs found on the top edge
  allTabs = new ArrayList();         
  
  //Arraylist of all buttons
  allButtons = new ArrayList();  
  
  //Arraylist of all events a team is registered for
  eventButtons = new ArrayList();
  
  //Initializing a public method object to use all its methods
  methodBank = new Methods();      
  
  //Initializing the imported GUI
  cp5 = new ControlP5(this);         

  //Create and place the search tab, this tab will be 
  //separated from the other because we want the user 
  //to use this tab to unlock the rest
  search = new Tab("Create an Event", 10);    


///////////////////////////////////////////////////////////////////
/*         SETUP FUNCTION -- TAB INITIALIZATION                  */ 
/*This function is in the Main Scouter class and runs once at the*/
/*beginning of the code. The purpose of this function is to      */ 
/*initialize all variables and objects                           */
///////////////////////////////////////////////////////////////////

  //create and place matches tab, used to see your matches and opponents
  matches = new Tab("Matches", 10);                  
  allTabs.add(matches);

  //create and place schedule tab, used to notify before a match and analyze opponents
  scheduleTab = new Tab("Schedules", allTabs.get(allTabs.size()-1).getRightXValue()+5);       
  allTabs.add(scheduleTab);
  setMethod(scheduleTab, "showScheduleTab");
  
  //create and place dock tab, used to import pictures and video from scouting
  Tab dockTab = new Tab("Dock", allTabs.get(allTabs.size()-1).getRightXValue()+5);                        
  allTabs.add(dockTab);
  
  //create and place review tab, used to review teams and review scounting material
  Tab review = new Tab("Review", allTabs.get(allTabs.size()-1).getRightXValue()+5);                    
  allTabs.add(review);

  //create and place my team tab tab, used to look at you team's stats
  myTeamTab = new Tab("My Team", allTabs.get(allTabs.size()-1).getRightXValue()+5);                
  allTabs.add(myTeamTab);
  //using the drawMyTeamTab method from methodBank to customize the myTeam tab
  setMethod(myTeamTab, "drawMyTeamTab");                      
  
///////////////////////////////////////////////////////////////////
/*  SETUP FUNCTION -- RANDOM OBJECT INITIALIZATION               */ 
/*This function is in the Main Scouter class and runs once at the*/
/*beginning of the code. The purpose of this function is to      */ 
/*initialize all variables and objects                           */
///////////////////////////////////////////////////////////////////

  //create a search bar to search for a team number
  teamSearch = new SearchBar(50, 100, 170, 30, "Team # + enter", "team_num=");       
  //and nest it in the search tab
  search.addObj(teamSearch);                              
  
  //create a text box for team stats which appears when a valid team 
  //is entered in the team seach bar
  teamStats = new TextBox(50, 260);                     
  
  //add the team stat text box to the search tab
  search.addObj(teamStats);                                                                             
  textAlign(RIGHT, TOP);
  
  //add text above the seach bar saying "Search for a Team"
  search.addObj(new TextBox("Search for a team: (required)", 50, 80));                                            
  textAlign(CENTER, CENTER);

  //create a button that will set my team to a valid team searched in the team search box
  setMyTeam = new Button("Press to Confirm", 240, 100, 180, 30, color(255));      
  //set a method to set my team to searched team from method bank for the setMyTeam button
  setMethod(setMyTeam, "setAsMyTeam");                                                                 

  //Create a button with the text search that will search for registered competition
  eventSearch = new Button("Search", 1030, 100, 80, 30, color(255));
  setMethod(eventSearch, "eventSearchButton");

  //Create a button with the text "Open Existing Event" that will open file explorer
  //and allow the user to select an event they have alreay started
  locateEvent = new Button("Open Existing Event", (width-(2*400))/2-200, 
  height/2-30, 400, 60, color(255), 20);
  setMethod(locateEvent, "selectEvent");

  //Create a button with the text "Create New Event" that 
  //will let the user select an event they are 
  //registered in and then unlock all the other tabs
  createEvent = new Button("Create New Event", 
  width-((width-(2*400))/2)-400+100, 
  height/2-30, 400, 60, color(255), 20);
  setMethod(createEvent, "createAnEvent");
  //search.addObj(locateMatchSchedule);

  //Create a button with the text "Create Duplicate Event" 
  //that will let the user duplicate an event they have
  //aready started
  createDuplicateEvent = new Button("Create Duplicate Event", 
  width-((width-(2*400))/2)-400+200, height/2-30, 400, 60, color(255), 20);
  setMethod(createDuplicateEvent, "createDuplicateEvent");
  
  //create a button that will allow the user to open an existing
  //event if the user tried to create an event that already exists
  openSearchedEvent = new Button("Open Existing Event", 
  (width-(2*400))/2-200, height/2-30, 400, 60, color(255), 20 );
  setMethod(openSearchedEvent, "selectExistingEvent");
  textAlign(CENTER, CENTER);
  
  //create a button to find the file directory of a scouter
  locateAScouter = new Button("Find Scouter", width/3, 
  height/3, 400, 60, color(0,180, 30), 20);
  setMethod(locateAScouter, "createAScouter");

  //create dropdown list that lets the user review their
  //only the matches they will be playing
  matchList = cp5.addListBox("Matches")
  
    //customize the dropdown list with color and sizes below
    .setPosition(50, 100)
    .setSize(400, 500)
    .setItemHeight(50)
    .setBarHeight(70)
    .setColorBackground(color(255, 128))
    .setColorActive(color(0))
    .setColorForeground(color(0, 100, 255))
    .setOpen(true)
    .hide()
    ;
    
  //set the fonts of the title and selections of the drop
  //down list
  matchList.getCaptionLabel().setFont(createFont("Calibri", 20));
  matchList.getValueLabel().setFont(createFont("Calibri", 15));
  matches.addControlObj(matchList);
  
  //create a button that invokes a method that identifies 
  //important matches to watch based on your schedule
  loadScheduleButton = new Button("Load Scouting Schedule", 
  50, 100, 300,30, color(255), 20);
    setMethod(loadScheduleButton, "createScoutingSchedule");
    dockTab.addObj(loadScheduleButton);
    
  //create a button that lets you increase the number of 
  //scouters you have
  addAScouter = new Button("+", 300, 150, 50, 50, color(255), 20);
    setMethod(addAScouter, "increaseScouterNumber");
    dockTab.addObj(addAScouter);
    
  //create a button that lets you increase the number of 
  //scouters you have
  removeAScouter = new Button("-", 50, 150, 50, 50, color(255), 20);
    setMethod(removeAScouter, "decreaseScouterNumber");
    dockTab.addObj(removeAScouter);
  
  //create a text box that displays the number of scouters you have
  displayNumOfScouter = new TextBox(""+numOfScouters, 
  150, 150, 100, 50, color(255));
    dockTab.addObj(displayNumOfScouter);
  
  dockTab.addObj(locateAScouter);
  availableMediaList = cp5.addListBox("Available Media:");
  
  availableMediaList.setPosition(width-300, 200);
  availableMediaList.hide();
  // a listbox that will let the user select the file they want to view
  customizeMediaListBox(availableMediaList);

}
///////////////////////////////////////////////////////////////////
/*                      DRAW FUNCTION                            */ 
/*This function handles all the sequencing and processing.       */
/*Any action the app does goes through this function.            */ 
/*This function is also looped so it is constanly updating       */
///////////////////////////////////////////////////////////////////
public void draw() {
  //clear the background every time
  background(0);
  
  if (!eventSelected) {

    if (!creatingAnEvent) {
      locateEvent.show(true);
      createEvent.show(true);
    } else {
      locateEvent.show(false);
      createEvent.show(false);
      search.show(true); 
      search.active = true;

      try {
        setMyTeam.show(searchTeam.getSize() > 0 && search.isSelected());
      }
      catch(Exception e) {
      }

      try {
        eventSearch.show(search.isSelected()&&(myTeam!=null));
      }
      catch(Exception e) {
      }
      for (Button b : eventButtons) {
        b.show(b.isShown && search.isSelected()) ;
      }
      for (Drawable d : search.getAllObjs()) {
        d.updateSelected();
      }

      if (myEvent != null) {
        creatingAnEvent = false;
        eventSelected = true;
        for (Button b : eventButtons) {
          b.show(false) ;
        }
        setMyTeam.show(false);
        eventSearch.show(false);
        File[] files = listFiles("./data/");
        for (File f : files) {
          if (f.getName().equals(myEvent.getName())) {
            doesEventExist = true;
            break;
          }
        }

        if (!doesEventExist) {
          File dir = new File("./data/", myEvent.getName().trim());
          dir.mkdir();
          PrintWriter writer = createWriter(dir+"/eventDetail.txt");
          writer.println("sku : "+myEvent.getSKU());
          writer.println("name : " + myEvent.getName());
          writer.println("team : " + myTeam.getTeamNumber());
          writer.flush();
          writer.close();
          myEvent.loadInfo();
        }
      }
    }

    matches.active = true;
  } else if (doesEventExist) {
    fill(255);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("This event already exists\nDo you want to", width/2, 100);
    textSize(30);
    openSearchedEvent.show(true);
    createDuplicateEvent.show(true);
  } else {
    for (Tab t : allTabs) {
      t.show(true);
    }

    for (Button b : eventButtons) {
      b.show(b.isShown && search.isSelected()) ;
    }

    if (matches.isSelected()) {
      myEvent.show();
    }
  }
}

public void mousePressed() {
  for (Tab t : allTabs) {
    t.togglePressed();
  }

  for (Tab t : allTabs) {
    if (t.isSelected()) {
      for (Drawable d : t.getAllObjs()) {
        d.updateSelected();
      }
    }
  }

  if (search.isSelected() && searchTeam!=null&&searchTeam.getSize() > 0) {
    setMyTeam.updateSelected();
  }
  if (search.isSelected()) {
    eventSearch.updateSelected();
  } else {
    eventSearch.show(false);
  }

  for (Tab t : allTabs) {
    if (t.isSelected()) {
      for (Drawable d : t.getAllObjs()) {
        d.updateSelected();
      }
    }
  }

  if (search.isSelected()) {
    for (Drawable d : eventButtons) {
      d.updateSelected();
    }
  }

  //println(monthDDL.getValue() + "   " + monthDDL.getItem((int)monthDDL.getValue()).get("value") + "    is updated: " + monthDDL.getId());
    //sender.sendMessage("+16788337013","Basiaclly made a bot to spam you everytime a press a key. If you are not naveen, I am so sorry");
  messageSent = true;
}

public void mouseReleased() {
  
}


public void keyPressed() {
  for (Tab t : allTabs) {
    if (t.isSelected()) {
      for (Drawable d : t.getAllObjs()) {
        if (d.isSelected()) {
          d.keyUpdate();
        }
      }
    }
  }
  if (search.isSelected()) {
    for (Drawable d : search.getAllObjs()) {
      if (d.isSelected()) {
        d.keyUpdate();
      }
    }
  }
  if (keyCode == ENTER) {
    if (teamSearch.isSelected()) {
      searchTeam = getTeam(teamSearch.getSearchQuery());
      if (searchTeam.getSize() > 0) {
        teamStats.setText("Team: " + searchTeam.getTeamNumber() + "\n" +
          "Name: " + searchTeam.getTeamName() + "\n" +
          "School: " + (searchTeam.getOrganization().length()>22?searchTeam.getOrganization().substring(0, 21) + "-\n" +
          searchTeam.getOrganization().substring(21)+"\n":searchTeam.getOrganization()) + "\n" +
          "Awards won: " + searchTeam.getAwardText().size());  
        setMyTeam.isShown = true;
      } else {
        teamStats.setText(teamSearch.getSearchQuery() + " does not exist");
        setMyTeam.isShown = false;
      }
      
    }
  }
  if (key == 'j') {
    myEvent.printMatches();
    println(myEvent);
  }
}


//this function retrieves data from a website in JSON format
//and stores it as a JSON object
public void requestData() {
  JSONObject json = loadJSONObject("http://time.jsontest.com/");
}
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
  
  public String getTrophyName(){
   return name; 
  }
  
  public String getTeamNumber(){
   return teamNumber; 
  }
  
  public String getSku(){
   return sku; 
  }
  public String getTournamentName(){
    try{
      return analyze(readURL("https://api.vexdb.io/v1/get_events?sku="+sku)).get(0).get(5)[1];
    }catch(Exception e){
      return null;
    }
  }
}
 //<>// //<>//
class Button implements Drawable {
  Method call;

  boolean isSelected;
  boolean isShown = true;
  String text;
  int c;
  int x;
  int y;
  int w;
  int h;
  Event obj;
  Team t;
  int tSize = 20;
  int lastTimeActivated = -1;

  Button(int x, int y, int w, int h, int c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.text = "";
    methodBank = new Methods();
  }
  Button(String text, int x, int y, int w, int h, int c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.text = text;
    textSize(tSize);
  }
  Button(String text, int x, int y, int w, int h, int c, int tSize) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.text = text;
    this.tSize = tSize;
    textSize(tSize);
  }

  Button() {
  }

  public void show(boolean isShown) {
    this.isShown = isShown;
    if (!mousePressed) {
      isSelected = false;
    } else {
      if (isShown) {
        if (mouseX > x && mouseX<x+w && mouseY > y && mouseY<y+h) {
          isSelected = true;
        } else {
          isSelected = false;
        }
      }
    }
    if (isShown) {
      if (isSelected&&!isFileSelectorOpen) {
        fill(red(c)-40, green(c)-40, blue(c)-40);
        updateSelected();
      } else {
        fill(c);
      }
      rect(x, y, w, h);

      fill(0);
      textSize(tSize);
      text(text, x+w/2, y+h/2);
    }
  }

  public void updateSelected() {

    if (isShown) { 
      if (mouseX > x && mouseX<x+w && mouseY > y && mouseY<y+h) {
        int currentTime = millis();
        if ((currentTime - lastTimeActivated)>300) {
          isSelected = true;
          // println("button pressed");
          if (call !=null) {
            try {
              if (obj==null) {
                //   println("invoked search");
                println("button method start");
                call.invoke(methodBank);   
                println("button method end");
                // println("finished search");
              } else {
                println("invoked setting the event");
                runMethod();
                println("finished setting the event");
                
              }
            }
            catch(Exception e) {
              println("button invoke error");
            }
          } else if (t != null) {
            teamButton();
          } else {
            println("call DNe");
            isSelected = false;
          }
          lastTimeActivated = currentTime;
        }
      }
    }
  }

  public boolean isSelected() {
    return isSelected;
  }

  public String keyUpdate() {
    return"";
  }

  public void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void setMethod(Method m) {
    call = m;
  }

  public void setMethod(Object o, Method m, Event e) {
    Object[] parameters = new Object[1];
    parameters[0] = e;
    call = m;
  }
  public void setMethod(Object o, Method m, Team e) {
    Object[] parameters = new Object[1];
    parameters[0] = e;
    call = m;
  }
  public void setButtonEvent(Event o) {
    obj=o;
  }

  public Object getObject() {
    return obj;
  }
  public void runMethod() {
    if (call!=null) {
      try {
        println("set obj");
        call.invoke(methodBank, obj);
      }
      catch(Exception e) {
        println(e.getCause() + " - button class");
      }
    } else {
      println("call DNE");
    }
  }
  public void setTeam(Team t) {
    this.t = t;
  }
  public void teamButton() {
    showMediaAvailableForTeam();
  }
  public void setColor(int c){
   this.c = c; 
  }
  public void showMediaAvailableForTeam(){
   if(t == null){
    println("Error: this button does not have a team linked to it");
   }else{
    println(t.getTeamNumber());
    availableMediaList.clear();
    for(File f : listFiles("./data/VideoData"))
      println(f.getName());
    availableMediaList.show(); 
   }
  }
}
//////////////////////////////////////////////////////////////////////
/*                   DRAWABLE INTERFACE                             */
/*This interface will be the outline for every object drawn on the  */
/*screen                                                            */
//////////////////////////////////////////////////////////////////////
interface Drawable{
 //draws the object on the screen
 public void show(boolean isShown);
 
 //this is what happens when the object is clicked
 public void updateSelected();
 
 //this return true/false depending if the object is selected
 public boolean isSelected();
 
 //this is the code that runs if the object is selected 
 //and you are typing
 public String keyUpdate();
 
 //sets the position on the screen where the object will be drawn
 public void setPos(int x, int y);
 
 //sets the method that will run when the object is clicked
 public void setMethod(Method m);
 
 //runs the set method for when it is clicked
 public void runMethod();
}
class dropDownList{
  
}
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
  public String getSKU() {
    return sku;
  }
  public void loadInfo() {        //loadInfo loads the information about matches and teams in an event
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


  public void drawMyMatches() {
    for (Map.Entry team : allTeams.entrySet()) {
      println("");
    }
  }
  public void createSchedule() {                                          //creates the schedule for mataches to go see and record
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


  public Team getTeam(String teamNumber) {
    try {
      return allTeams.get(teamNumber);
    }
    catch(Exception e) {
      return null;
    }
  }

  public String toString() {
    //readResults(analyze(readURL("https://api.vexdb.io/v1/get_teams?sku="+sku)));
    return  "" + allTeams.size();
  }
  public HashMap getMap() {
    return allTeams;
  }
  public void printMatches() {
    for (Match m : myMatches) {

      println(m.toString());
    }
  }
  public String getName() {
    return name;
  }

  public void show() {
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
  public ArrayList<Team> getOpponents() {
    return allOpponents;
  }
}
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
  Team[] playingTeams = new Team[4];
  Button[] teamButtons = new Button[4];
  int round; //1 - practice || 2 - Qualificaction || 3 - Quarter Fin || 4 - Semi Fin || 5 - Final
  int matchImportance;
  int x = 600;
  int y = 100;
  int w = 150;
  int h = 30;
  Match(ArrayList<String[]> arr) {
    division = arr.get(2)[1];
    matchNum = Integer.parseInt(arr.get(5)[1]);
    round = PApplet.parseInt(arr.get(2)[1]);
    red1 = (Team)myEvent.getMap().get(arr.get(7)[1]);
    red2 = (Team)myEvent.getMap().get(arr.get(8)[1]);
    
    blue1 = (Team)myEvent.getMap().get(arr.get(11)[1]);
    blue2 = (Team)myEvent.getMap().get(arr.get(12)[1]);
    //try{
    playingTeams[0] = red1;
    playingTeams[1] = red2;
    playingTeams[2] = blue1;
    playingTeams[3] = blue2;
    r1 = new Button(red1.getTeamNumber(), x, y, w, h, color(255, 100, 100));
    r1.setTeam(red1);
    r2 = new Button(red2.getTeamNumber(), x+160, y, w, h, color(255, 100, 100));
    r2.setTeam(red2);

    b1 = new Button(blue1.getTeamNumber(), x+(160*2), y, w, h, color(100, 100, 255));
    b1.setTeam(blue1);   
    b2 = new Button(blue2.getTeamNumber(), x+(160*3), y, w, h, color(100, 100, 255));
    b2.setTeam(blue2);
    teamButtons[0] = r1;
    teamButtons[1] = r2;
    teamButtons[2] = b1;
    teamButtons[3] = b2;
    
    try{
    }catch(Exception e){
      println("Exception occured in this match: ");
      for(String[] l : arr){
       for(String s : l) {
         print(s + "\t");
      }
      println();
    }
    }
    for(Button b : teamButtons){
      
    }
    matchImportance = 0;
  }

  public void drawMatch() {
    fill(255);
    text("Q"+matchNum, x+(160*2)-10, 50);
    r1.show(true);
    r2.show(true);
    b1.show(true);
    b2.show(true);
  }
  public Team getBlue1Team() {
    return blue1;
  }
  public Team getRed1Team() {
    return red1;
  }  
  public Team getBlue2Team() {
    return blue2;
  }
  public Team getRed2Team() {
    return red2;
  }
  public int getMatchNum() {
    return matchNum;
  }
  public String toString() {
    try {
      return "Q" + matchNum +"\t\t"+red1.getTeamNumber() + " & " + red2.getTeamNumber() + "\tv\t" + blue1.getTeamNumber() + " & " + blue2.getTeamNumber();
    }
    catch(Exception e) {
      return e.toString() + "\t" + e.getCause() + "matches:toString()";
    }
  }

  public Team[] getOpponents() {

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
  public boolean hasOpponent(Team t) {
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
  public ArrayList<Team> getAllOpponents() {
    ArrayList<Team> opps = new ArrayList(); 

    for (Team s : playingTeams) {
      if (s.isOpponent()) {
        opps.add(s);
      }
    }
    return opps;
  }
  public void increaseImportance() {
    matchImportance++;
  }
  public int getImportance() {
    return matchImportance;
  }
  public void setImportance(int imp) {
    matchImportance = imp;
  }
}

class Methods {
  Methods() {
  }
  public void setAsMyTeam() {
    myTeam = searchTeam;
    myTeamTab.rename(myTeam.getTeamNumber());
    eventSearchButton();
  }

  public void drawMyTeamTab() {
    if (myTeam != null) {
      fill(255);
      text(myTeam.getTeamNumber(), 50, 100);
    }
  }

  public void drawSearchTab() {
    line(300, 0, 300, height);
  }
  public void setMyEvent(Event e) {

    myEvent = e;
    myEvent.loadInfo();
    search.active = false;
    matches.active = true;


    println("set event");
  }
  public void eventSearchButton() {
    ArrayList<ArrayList<String[]>> events;
    String url = "https://api.vexdb.io/v1/get_events?";
    url+= "team="+myTeam.getTeamNumber();
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
  public void createAnEvent() {
    println("creating an event");
    creatingAnEvent = true;
  }
  public void selectEvent() {
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
  public void selectExistingEvent() {
    doesEventExist = false;
  }
  public void createDuplicateEvent() {
    File dir = new File("./data/", myEvent.getName()+"-Duplicate");
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

  public void showSelectedMatch() {
  }

  public void teamSelected(Object o) {
    println(((Team)o).getTeamName());
  }
  public void showScheduleTab() {
    if (myEvent.isScoutScheduleCreated) {
      for (int i = 0; i < myEvent.scoutSchedule.size(); i++) {
        fill(255);
        textAlign(LEFT, TOP);
        text("" + i + ":\t" + myEvent.scoutSchedule.get(i).toString(), 50, 100+100*i);
        textAlign(CENTER, CENTER);
      }
    }
  }
  public void createScoutingSchedule() {
    myEvent.createSchedule(); //goes to my event and runs code to create a scouting schedule for the schedule with the given number of scouters
    if (myEvent.scoutScheduleList.size()>0) {
      loadScheduleButton.setColor(color(0, 255, 55));
    } else {
      loadScheduleButton.setColor(color(255, 55, 0));
    }
    scheduleTab.setActive();
  }

  public void increaseScouterNumber() {
    if (numOfScouters<5) {
      numOfScouters++; 
      displayNumOfScouter.setText(""+numOfScouters);
    }
  }
  public void decreaseScouterNumber() {
    if (numOfScouters>1) {
      numOfScouters--; 
      displayNumOfScouter.setText(""+numOfScouters);
    }
  }
  public void createAScouter() {
    if (!isFileSelectorOpen) {
      isFileSelectorOpen = true;
      try {
        selectFolder("select the phone", "scouterPhoneSelected", new File("../"));
      }
      catch(Exception e) {
        println(e + " - loacting scouter from file");
        isFileSelectorOpen = false;
      }
    }
  }
}



////////////////////////////////////////////////////////////////////////////////////public static methods//////////////////////////////////////////////////////////
/*                                                                                                                                                                */
/*                                                                                                                                                                */
/*                                                                                                                                                                */
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public static String readURL(String urlString) {//function takes a URL
  BufferedReader br = null;
  StringBuilder sb = new StringBuilder();
  try {                                        //we try to access the webpage
    URL url = new URL(urlString);              //if successful, the webpage will return texts as data
    br = new BufferedReader(new InputStreamReader(url.openStream()));
    String line;                               //we read and append those lines of texts 
    while ((line = br.readLine()) != null) {   //together into one long line and return it
      sb.append(line);
      sb.append(System.lineSeparator());
    }
  } 
  catch(Exception e) {
  }
  return sb.toString();
}

public static ArrayList<ArrayList<String[]>> analyze(String s) {
  //create an instance of the text data that we get from the data base
  String finString = s;          
  //format the string to remove excess syntax
  finString = finString.replace("{", "").replace("result\":", "").
  replace("[", "")    .replace("\"", "").replace("]", "")
  .replace(" number", "number").trim();
  try {
    finString = finString.substring(finString.indexOf("size"));
  }
  catch(Exception e) {
  }
  //create an empty array list that we will populate and return
  ArrayList<ArrayList<String[]>> results = new ArrayList();
  //split for every JSON object
  String[] shotgunned = finString.split("}");

  for (String str : shotgunned) {
    ArrayList<String[]> dataEntry = new ArrayList();
    //for every object, split it apart to 
    //display the variables and adata
    for (String data : str.split(",")) {
      data.trim();
      dataEntry.add(data.split(":"));
    }
    //add the entry we retrieved from the database
    results.add(dataEntry);
  }
  //return the populated arraylist of results
  return results;
}

public static void readResults(ArrayList<ArrayList<String[]>> c) {
  //this method takes the list of JSON objects,
  for (ArrayList<String[]> d : c) {
  //for every object, it gets an array of strings 
  //formatted as {key, value} which is a variable
    for (String[] e : d) {
      //for each variable, it will print it out the key and value
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
public Team getTeam(String teamNumber) {
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

public void customizeMediaListBox(ListBox ddl) { 
  //a convenience function made to customize the mediaListBox used to select videos
  ddl.setBackgroundColor(color(255));
  ddl.setItemHeight(30);
  ddl.setBarHeight(30);
  ddl.setSize(300, 500);
  ddl.setColorBackground(color(150));
  ddl.setColorActive(color(255, 128));
  ddl.setColorLabel(0);
  ddl.setColorValueLabel(0); 
  ddl.getCaptionLabel().setFont(createFont("Calibri", 20));
  ddl.getValueLabel().setFont(createFont("Calibri", 15));
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
public static void selectPhone() {
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
class Scout{
 File scouterPath;
 Scout(File F){
 }
 
 public ArrayList<File> getNewData(File path){
   currentFiles.clear();
   for(File f : currentLocation.listFiles()){
     currentFiles.add(f);
   }
   scouterPath = path;
   ArrayList<File> newData = new ArrayList();
   for(File f : scouterPath.listFiles()){
     if(!currentFiles.contains(f)){
       new File("/../"+f.getName()).mkdir();
     }
   }
   
   return newData;
 }
}

public void scouterPhoneSelected(File selection){
  allScouts.add(new Scout(selection));
  println(selection.getAbsolutePath());
  //if(File(currentLocation+"/"))
}
class SearchBar implements Drawable {
  String searchQuery = "";
  String fadedText;
  boolean isSelected;
  boolean isShown;
  int x;
  int y;
  int w;
  int h;
  Method call;
  SearchBar(int x, int y, int w, int h, String fadedText, String searchObj) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fadedText = fadedText;
  }
    SearchBar(int x, int y, int w, int h, String fadedText) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fadedText = fadedText;
  }
  SearchBar(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fadedText = "";
  }


  public String keyUpdate() {
    if (Character.isLetter(key) || Character.isDigit(key)) {
      searchQuery += key;
    } else if (keyCode == BACKSPACE) {
      try {
        searchQuery = searchQuery.substring(0, searchQuery.length()-1);
      }
      catch(Exception e) {
      }
    } else if (keyCode == DELETE) {
    }
    return searchQuery;
  }

  public void updateSelected() {
    if (mousePressed)
    if (mouseX > x && mouseX<x+w && mouseY > y && mouseY<y+h) {
      isSelected = true;
    } else {
      isSelected = false;
    }
  }

  public String getSearchQuery() {
    return searchQuery;
  }

  public void show(boolean isShown) {
    this.isShown = isShown;
    if (isShown) {
      if (isSelected) {
        fill(255);
      } else {
        fill(150);
      }
      rect(x, y, w, h);    
      textSize((int)(h*0.7f));

      if (searchQuery.equals("")) {
        fill(100);
        text(fadedText, x+w/2, y+h/2);
      } else {
        fill(0);
        text(searchQuery, x+w/2, y+h/2);
      }
    }
    runMethod();
  }

  public boolean isSelected() {
    return isSelected && isShown;
  }

  public void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void setMethod(Method m) {
    call = m;
  }

  public void runMethod() {
    if (call!=null) {
      try {
        call.invoke(methodBank);
      }
      catch(Exception e) {
      }
    }
  }
}
class Tab implements Drawable {
  String name;
  ArrayList<Drawable> objs = new ArrayList();
  ArrayList<Controller> controlObjs = new ArrayList();
  boolean active;
  int x;
  int y;
  int pX;
  Method call;
  Tab(String text, int lastX) {
    x = lastX;
    name = text;
    pX = lastX + name.length()*12+10;
    active = false;
    y = 40;
  }

  public void show(boolean b) {
    if (b) {
      if (active) {
        fill(200, 200, 255);
      } else {
        fill(255);
      }    
      rect(x, 10, pX-x, 45);

      textSize(20);
      fill(0);
      text(name, x+(pX-x)/2, y-10);

      for (Drawable d : objs) {
        d.show(active);
      }
      for(Controller c : controlObjs){
       if(active){
        c.show(); 
       }else{
        c.hide(); 
       }
      }
      if (call!=null && active)
      try {
        call.invoke(methodBank);
      }
      catch(Exception e) {
        println("tab error");
      }
    }else{
     for(Controller c : controlObjs){
       c.hide();
     }
    }
  }


  public boolean togglePressed() {
    if ( mouseY>10 && mouseY<50 ) {
      if (mouseX>x && mouseX<pX) {
        active = true; 
        return true;
      } else {
        active = false;
        return false;
      }
    } else {
      return active;
    }
  }

  public int getRightXValue() {
    return pX;
  }

  public void addObj(Drawable d) {
    objs.add(d);
  }
  
  public void addControlObj(Controller c){
    controlObjs.add(c);
  }

  public boolean isSelected() {
    return active;
  }

  public ArrayList<Drawable> getAllObjs() {
    return objs;
  }

  public void updateSelected() {
    togglePressed();
  }
  
  public void setPos(int x, int y){
    this.x = x;
    this.y = y;
  }
  public void setMethod(Method m) {
    call = m;
  }

  public void runMethod() {
    if (call!=null) {
      try {
        call.invoke(methodBank);
      } 
      catch(Exception e) {
      }
    }
  }
  public String keyUpdate(){
    return "";
  }
  public void rename(String n){
   name =  n;
  }
  public void setActive(){
   for(Tab tab : allTabs){
    tab.active = false; 
   }
   active = true;
  }
}
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
  boolean isOpponent = false;

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
          try {
            organization = (String)ent.get(1);
          }
          catch(Exception e) {
            organization = "NULL";
          }
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
        print(teamNumber+"\t");
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
       try {
            organization = (String)s[0];
          }
          catch(Exception e) {
            organization = "NULL";
          }
      } else if (s[0].equals("city")) {
        city = (String)s[1];
      } else if (s[0].equals("region")) {
        try {
          region = (String)s[1];
        }
        catch(Exception e) {
          region = "NULL";
        }
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

  public ArrayList<Award> getAllAwards() {
    return allAwards;
  }

  //ArrayList<Award> getAwardsFrom(String season){

  //}
  public String getAwards(String season) {
    return "none";
  }
  public int getSize() {
    return size;
  }
  public String getTeamNumber() {
    return teamNumber;
  }
  public String getTeamName() {
    return teamName;
  }
  public String getOrganization() {
    return organization;
  }
  public String getProgram() {
    return program;
  }
  public String toString() {
    return teamNumber;
  }
  public int getTimesCovered(){
   return timesCovered;
  }
  public void increaseTimesCovered(){
    timesCovered++;
  }
  public boolean isOpponent(){
   return isOpponent; 
  }
  public void setIsOpponent(boolean b){
   isOpponent = b; 
  }
}
class TextBox implements Drawable {
  int x;
  int y;
  int w = -1;
  int h = -1;
  boolean isShown;
  String text;
  int c;
  boolean isBox = false;
  Method call;

  TextBox(String text, int x, int y, int w, int h, int c) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    isBox = true;
  }

  TextBox(String text, int x, int y) {
    this.text = text;
    this.x = x;
    this.y = y;
  }

  TextBox(int x, int y) {
    this.text = "";
    this.x = x;
    this.y = y;
  }

  public void show(boolean isShown) {
    this.isShown = isShown;
    if (isShown) {
      if (isBox) {
        fill(c);
        rect(x, y, w, h);
        fill(0);
        textAlign(CENTER, CENTER);
        text(text, x+w/2, y+h/2);
      } else {
        fill(255);
        textAlign(LEFT, CENTER);
        text(text, x, y);
        textAlign(CENTER, CENTER);
      }
    }
    runMethod();
  }

  public void updateSelected() {
  }

  public boolean isSelected() {
    return false;
  }

  public String keyUpdate() {
    return "";
  }

  public void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void setText(String text) {
    this.text = text;
  }

  public void setMethod(Method m) {
    call = m;
  }

  public void runMethod() {
    if (call!=null) {
      try {
        call.invoke(methodBank);
      }
      catch(Exception e) {
      }
    }
  }
}
  public void settings() {  size(1500, 700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Scouter" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
