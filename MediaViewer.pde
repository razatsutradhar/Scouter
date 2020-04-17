class MediaViewer implements Drawable {
  ArrayList<File> allMedia, allText, allImage;
  int x = 0, y = 0;
  int slide = -1;
  String team = "", protectedAut = "", unprotectedAut = "", strengths = "", weaknesses = "";
  boolean auton = false, incLastPressed = false, decLastPressed = false, show = false;
  int space = 25;
  Button increaseBtn, decreaseBtn, rotatePositive, rotateNegative;
  PImage img;
  MediaViewer(int x, int y) {
    try {
      allMedia = new ArrayList();
      allText = new ArrayList();
      allImage = new ArrayList();
      this.x = x;
      this.y = y;
      increaseBtn = new Button(">", x + 700, height/2, 30, 60, color(180), 30);
      decreaseBtn = new Button("<", x - 100, height/2 , 30, 60, color(180), 30);
      rotatePositive = new Button("+90", x - 100, y , 30, 30, color(180), 30);
      rotateNegative = new Button("-90", x - 100, y , 30, 30, color(180), 30);
      increaseBtn.show(false);
      decreaseBtn.show(false);
    }
    catch(Exception e) {
      println(e.getCause());
    }
  }

  void clearMedia() {
    allMedia.clear(); 
    allText.clear(); 
    allImage.clear();
    team = ""; 
    protectedAut = ""; 
    unprotectedAut = ""; 
    strengths = ""; 
    weaknesses = "";
    auton = false; 
    incLastPressed = false; 
    decLastPressed = false; 
    show = false;
    slide = -1;
  }

  void add(File f) {
    allMedia.add(f);
    if (f.getName().toLowerCase().contains(".txt")) {
      allText.add(f);
    } else {
      allImage.add(f);
    }
  }

  ArrayList<File> getAllTextFiles() {
    ArrayList<File> result = new ArrayList();
    for (File f : allMedia) {
      if (f.getName().toLowerCase().contains(".txt")) {
        result.add(f);
      }
    }
    return result;
  }
  ArrayList<File> getAllImageFile() {
    ArrayList<File> result = new ArrayList();
    for (File f : allMedia) {
      if (!f.getName().toLowerCase().contains(".txt")) {
        result.add(f);
      }
    }
    return result;
  }

  String readFile(File f) {
    try {
      BufferedReader br = new BufferedReader(new FileReader(f)); 
      String total = "";
      String st; 
      while ((st = br.readLine()) != null) 
        total += (st + "\n");
      br.close();
      return total;
    }
    catch(Exception e) {
      return "";
    }
  }

  String[] getSplitArray(File f) {
    return readFile(f).split("\n");
  }

  void parseAllTextFiles() {
    ArrayList<File> allText = getAllTextFiles(); 
    for (File f : allText) {
      for (String line : getSplitArray(f)) {
        line = line.toLowerCase();
        String[] shotgun = line.split(":");
        if (shotgun.length == 2)
          switch(shotgun[0].toLowerCase().trim()) {
          case "team":
            team = shotgun[1].toUpperCase().trim();
            break;
          case "auton":
            if (Boolean.parseBoolean(shotgun[1].toLowerCase().trim())) {
              auton = true;
            }
            break;
          case "protected":
            protectedAut += shotgun[1] + ",";
            break;
          case "unprotected":
            unprotectedAut += shotgun[1] + ",";
            break;
          case "strength":
            strengths += shotgun[1] + "\n";
            break;
          case "weakness":
            weaknesses += shotgun[1] + "\n";
            break;
          }
      }
    }
    println("team: " + team);
    println("has auton: " + auton);
    println("protected Auton: " + protectedAut);
    println("unprotected Auton: " + unprotectedAut);
    println("strengths: " + strengths);
    println("weaknesses: " + weaknesses);
  }
  String getTeam() {
    return team;
  }
  boolean hasAuton() {
    return auton;
  }
  String getProtectedScores() {
    return protectedAut;
  }
  String getUnprotectedScores() {
    return unprotectedAut;
  }
  String getStrengths() {
    return strengths;
  }
  String getWeaknesses() {
    return weaknesses;
  }
  String addLinebreaks(String input, int maxLineLength) {
    StringTokenizer tok = new StringTokenizer(input, " ");
    StringBuilder output = new StringBuilder(input.length());
    int lineLen = 0;
    while (tok.hasMoreTokens()) {
      String word = tok.nextToken();

      if (lineLen + word.length() > maxLineLength) {
        output.append("\n");
        lineLen = 0;
      }
      output.append(word);
      lineLen += word.length();
    }
    return output.toString();
  }
  //draws the object on the screen
  void show(boolean isShown) {
    show = isShown;
    if (isShown) {
      fill(255);
      textAlign(LEFT, TOP);
      if (allMedia.size() == 0 && !team.equals("")) {
        text("No media available for " + team, x, y);
      } else if (allText.size() > 0 && slide == -1) {
        text(team, x, y);
        text((auton?"Has auton(s)":"No autons recorded"), x, y+2*space);
        text((protectedAut.length() -1) > 0 ? "Protected: " + protectedAut.substring(0, protectedAut.length() -1): "none", x, y+3*space);
        text((unprotectedAut.length() -1) > 0 ? "Unprotected: " + unprotectedAut.substring(0, unprotectedAut.length() -1): "none", x, y+4*space);
        text("Strenghts: \n" + addLinebreaks(strengths, 50), x, y+5*space);
        text("Weaknesses: \n" + addLinebreaks(weaknesses, 50), x+500, y+5*space);
      } else if (allText.size()==0 && slide == -1) {
        text("No notes available", x, y);
      }

      if (slide < allImage.size()-1) {
        increaseBtn.show(true);
      } else {
        increaseBtn.show(false);
      }

      if (slide > -1) {
        decreaseBtn.show(true);
      } else {
        decreaseBtn.show(false);
      }

      if (increaseBtn.isPressed()) {
        slide++; 
        if (slide < allImage.size() && slide >= 0) {
          img = loadImage(allImage.get(slide).getPath());
        }
        println("increase: " + slide);
      }
      if (decreaseBtn.isPressed()) {
        slide--; 
        if (slide < allImage.size() && slide >= 0) {
          img = loadImage(allImage.get(slide).getPath());
        }
        println("Decrease: " + slide);
      }
      
      if(rotatePositive.isPressed()){
        
      }else if(rotateNegative.isPressed()){
        
      }
      
      if(slide != -1 && img != null){
        rotatePositive.show(true);
        rotateNegative.show(true);
        image(resize(img, 625,700), x,y);
      }
    }
  }

  //this is what happens when the object is clicked
  void updateSelected() {
  }

  //this return true/false depending if the object is selected
  boolean isSelected() {
    return false;
  }

  //this is the code that runs if the object is selected 
  //and you are typing
  String keyUpdate() {
    return " ";
  }

  //sets the position on the screen where the object will be drawn
  void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  } 
  //sets the method that will run when the object is clicked
  void setMethod(Method m) {
  }

  //runs the set method for when it is clicked
  void runMethod() {
  }
  void setTeam(String s) {
    team = s;
  }
  
  PImage resize(PImage img, int maxWidth, int maxHeight){
   int w = img.width;
   int h = img.height;
   
   if(float(w)/maxWidth > float(h)/maxHeight){
    img.resize(maxWidth, int(h/(float(w)/maxWidth)));
    return img;
   }else{
     img.resize(maxWidth, int(h/(float(w)/maxWidth)));
     return img;
   }
  }
  
  void rotateAndShow(PImage img, int deg, int x, int y){
    color[] result = new color[img.pixels.length];
    
    
  }
}
