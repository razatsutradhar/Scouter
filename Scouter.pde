import java.net.*;
import java.io.*;
import java.lang.reflect.Method;
import controlP5.*;
import java.util.*;
import com.hamzeen.sms.*;
import javax.*;

SendSms sender;
boolean messageSent;

PImage icon; 
static String matchSchedulePath;
ArrayList<Tab> allTabs;              //array that holds all the 
ArrayList<Button> allButtons;        //array of all button objects
SearchBar teamSearch;                //search bar that you type your team name into, found under search tab        
TextBox teamStats;                   //if a team is found from team search, this shows information on that team
static Team searchTeam;              //the team object of the team found from the search query in search tab
static Team myTeam;                  //global varaiable for my team. Can be set in the search tab
Button setMyTeam;                    //button displayed after a valid team is found from a search query. Will set that team to "myTeam"
Tab search;                          //first tab, labeled "search", used to loacte you team and the event
static ControlP5 cp5;                //class for imported GUI
Methods methodBank;                  //class to hold all public static method and to pass methods as a variable (read more in Methods)
static DropdownList monthDDL;               //search tab, drop down list used to pick month of an event
static DropdownList dateDDL;                //search tab, drop down list used to pick date of an event
static DropdownList yearDDL;                //search tab, drop down list used to pick year of an event
Button eventSearch;                  //use entered date to search for events on that day
Tab myTeamTab;
Tab matches;
ArrayList<Button> eventButtons;
Event myEvent;
Table schedule;
Button locateEvent;
Button createEvent;
Button createDuplicateEvent;
Button openSearchedEvent;
boolean isFileSelectorOpen = false;
boolean creatingAnEvent = false;
boolean eventSelected = false;
String scheduleAbsolutePath;
String eventFolderPath;
boolean doesEventExist = false;
ListBox matchList;

Button loadScheduleButton;
int numOfScouters = 1;
TextBox displayNumOfScouter;
Button addAScouter;
Button removeAScouter;

ListBox availableMediaList;
void setup() {

  size(1500, 700);                   //size of the window
  icon = loadImage("logopng.png");
  icon.resize(564, 564);
  surface.setIcon(icon);
  allTabs = new ArrayList();         //Arraylist of all tabs found on the top edge
  allButtons = new ArrayList();      //Arraylist of all buttons
  eventButtons = new ArrayList();
  methodBank = new Methods();        //Initializing a public method object to use all its methods
  cp5 = new ControlP5(this);         //Initializing the imported GUI

  search = new Tab("Create an Event", 10);    //Create and place the search tab

  matches = new Tab("Matches", 10);                  //create and place matches tab, used to see your matches and opponents
  allTabs.add(matches);

  Tab scheduleTab = new Tab("Schedules", allTabs.get(allTabs.size()-1).getRightXValue()+5);       //create and place schedule tab, used to notify before a match and analyze opponents
  allTabs.add(scheduleTab);

  Tab dockTab = new Tab("Dock", allTabs.get(allTabs.size()-1).getRightXValue()+5);                        //create and place dock tab, used to import pictures and video from scouting
  allTabs.add(dockTab);

  Tab review = new Tab("Review", allTabs.get(allTabs.size()-1).getRightXValue()+5);                    //create and place review tab, used to review teams and review scounting material
  allTabs.add(review);

  myTeamTab = new Tab("My Team", allTabs.get(allTabs.size()-1).getRightXValue()+5);                //create and place my team tab tab, used to look at you team's stats
  allTabs.add(myTeamTab);

  setMethod(myTeamTab, "drawMyTeamTab");                                                               //using the drawMyTeamTab method from methodBank to customize the myTeam tab

  teamSearch = new SearchBar(50, 100, 170, 30, "Team # + enter", "team_num=");                                 //create a search bar to search for a team number
  search.addObj(teamSearch);                                                                           //and nest it in the search tab

  teamStats = new TextBox(50, 260);                                                                    //create a text box for team stats which appears when a valid team is entered in the team seach bar
  search.addObj(teamStats);                                                                            //add the team stat text box to the search tab 
  textAlign(RIGHT, TOP);
  search.addObj(new TextBox("Search for a team: (required)", 50, 80));                                            //add text above the seach bar saying "Search for a Team" 
  search.addObj(new TextBox("Select date of event (optional)", 600, 80));                                            //add text above the seach bar saying "Search for a Team" 
  textAlign(CENTER, CENTER);

  setMyTeam = new Button("Press to Confirm", 240, 100, 180, 30, color(255));                             //create a button that will set my team to a valid team searched in the team search box
  setMethod(setMyTeam, "setAsMyTeam");                                                                 //set a method to set my team to searched team from method bank for the setMyTeam button

  yearDDL = cp5.addDropdownList("Year").setPosition(500, 100).setSize(150, 200);                        //create a dropdownlist for YEARS, customize it, and add it to the search tab
  customizeNumberDDL(yearDDL, 2018, 2021);
  search.addControlObj(yearDDL);

  monthDDL = cp5.addDropdownList("Month").setPosition(680, 100).setSize(150, 200);                      //create a dropdownlist for MONTHS, customize it, and add it to the search tab
  customizeMonthDDL(monthDDL);
  search.addControlObj(monthDDL);

  dateDDL = cp5.addDropdownList("Day").setPosition(860, 100).setSize(150, 200);                         //create a dropdownlist for DATES, customize it, and add it to the search tab
  customizeNumberDDL(dateDDL, 1, 31);
  search.addControlObj(dateDDL);

  eventSearch = new Button("Search", 1030, 100, 80, 30, color(255));
  setMethod(eventSearch, "eventSearchButton");


  locateEvent = new Button("Open Existing Event", (width-(2*400))/2-200, height/2-30, 400, 60, color(255), 20);
  setMethod(locateEvent, "selectEvent");

  createEvent = new Button("Create New Event", width-((width-(2*400))/2)-400+100, height/2-30, 400, 60, color(255), 20);
  setMethod(createEvent, "createAnEvent");
  //search.addObj(locateMatchSchedule);

  createDuplicateEvent = new Button("Create Duplicate Event", width-((width-(2*400))/2)-400+200, height/2-30, 400, 60, color(255), 20);
  setMethod(createDuplicateEvent, "createDuplicateEvent");
  
  openSearchedEvent = new Button("Open Existing Event", (width-(2*400))/2-200, height/2-30, 400, 60, color(255), 20 );
  setMethod(openSearchedEvent, "selectExistingEvent");
  textAlign(CENTER, CENTER);

  matchList = cp5.addListBox("Matches")
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
  matchList.getCaptionLabel().setFont(createFont("Calibri", 20));
  matchList.getValueLabel().setFont(createFont("Calibri", 15));
  matches.addControlObj(matchList);
  
  loadScheduleButton = new Button("Load Scouting Schedule", 50, 100, 300,30, color(255), 20);
    setMethod(loadScheduleButton, "createScoutingSchedule");
    dockTab.addObj(loadScheduleButton);
  addAScouter = new Button("+", 300, 150, 50, 50, color(255), 20);
    setMethod(addAScouter, "increaseScouterNumber");
    dockTab.addObj(addAScouter);
  removeAScouter = new Button("-", 50, 150, 50, 50, color(255), 20);
    setMethod(removeAScouter, "decreaseScouterNumber");
    dockTab.addObj(removeAScouter);
  displayNumOfScouter = new TextBox(""+numOfScouters, 150, 150, 100, 50, color(255));
    dockTab.addObj(displayNumOfScouter);
  
  availableMediaList = cp5.addListBox("Available Media:")
    .setPosition(width-100, 150)
    .setSize(50, 800)
    .setItemHeight(50)
    .setBarHeight(40)
    .setColorBackground(color(255, 128))
    .setColorActive(color(0))
    .setColorForeground(color(0, 100, 255))
    .setOpen(true)
    .hide()
    ;

   org.apache.log4j.BasicConfigurator.configure();

  // check the port which your device (modem/dongle) is attached & replace below.
  sender = new SendSms("modem.com1", "COM14", 19200, "Huawei", "E220", "+17708731155");
}

void draw() {

  background(0);
  if (!eventSelected) {

    if (!creatingAnEvent) {
      monthDDL.hide();
      dateDDL.hide();
      yearDDL.hide();

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
        eventSearch.show(search.isSelected()&&(myTeam!=null || yearDDL.getId() != -1));
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
        File[] files = listFiles("./");
        for (File f : files) {
          if (f.getName().equals(myEvent.getName())) {
            doesEventExist = true;
            break;
          }
        }

        if (!doesEventExist) {
          File dir = new File("./", myEvent.getName());
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
  getDate();
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
  yearDDL.update();
  monthDDL.update();
  dateDDL.update();
  //for (Tab t : allTabs) {
  //  if (t.isSelected()) {
  //    for (Drawable d : t.getAllObjs()) {
  //      d.updateSelected();
  //    }
  //  }
  //}

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

void requestData() {
  JSONObject json = loadJSONObject("http://time.jsontest.com/");
}
