import java.lang.reflect.Method; //<>// //<>//
class Button implements Drawable {
  Method call;

  boolean isSelected;
  boolean isShown = true;
  String text;
  color c;
  int x;
  int y;
  int w;
  int h;
  Event obj;
  Team t;
  int tSize = 20;
  int lastTimeActivated = -1;

  Button(int x, int y, int w, int h, color c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.text = "";
    methodBank = new Methods();
  }
  Button(String text, int x, int y, int w, int h, color c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.text = text;
    textSize(tSize);
  }
  Button(String text, int x, int y, int w, int h, color c, int tSize) {
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

  void show(boolean isShown) {
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

  void updateSelected() {

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

  boolean isSelected() {
    return isSelected;
  }

  String keyUpdate() {
    return"";
  }

  void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void setMethod(Method m) {
    call = m;
  }

  void setMethod(Object o, Method m, Event e) {
    Object[] parameters = new Object[1];
    parameters[0] = e;
    call = m;
  }
  void setMethod(Object o, Method m, Team e) {
    Object[] parameters = new Object[1];
    parameters[0] = e;
    call = m;
  }
  void setButtonEvent(Event o) {
    obj=o;
  }

  Object getObject() {
    return obj;
  }
  void runMethod() {
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
  void setTeam(Team t) {
    this.t = t;
  }
  void teamButton() {
    showMediaAvailableForTeam();
  }
  void setColor(color c){
   this.c = c; 
  }
  void showMediaAvailableForTeam(){
   if(t == null){
    println("Error: this button does not have a team linked to it");
   }else{
    println(t.getTeamNumber());
    availableMediaList.show(); 
   }
  }
}
