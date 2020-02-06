///////////////////////////////////////////////////////////////////
/*                    Scouter Main                               */ 
/*This class houses all the void draw and setup function which   */
/*braches out and works with all the other classes. This is the  */ 
/*central hub of this entire app                                 */
///////////////////////////////////////////////////////////////////

import java.net.*;
import java.io.*;
import java.lang.reflect.Method;
import controlP5.*;
import java.util.*;
import javax.*;


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
void setup() {
  size(1500, 700);                   //size of the window
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
void draw() {
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

void mousePressed() {
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

void mouseReleased() {
  
}


void keyPressed() {
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
void requestData() {
  JSONObject json = loadJSONObject("http://time.jsontest.com/");
}
