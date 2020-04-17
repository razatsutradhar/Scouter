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

  void show(boolean b) {
    if (b) {
      if (active) {
        fill(200, 200, 255);
      } else {
        fill(255);
      }    
      rect(x, 10, pX-x, 45);

      textSize(20);
      textAlign(CENTER,CENTER);
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


  boolean togglePressed() {
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

  int getRightXValue() {
    return pX;
  }

  void addObj(Drawable d) {
    objs.add(d);
  }
  
  void addControlObj(Controller c){
    controlObjs.add(c);
  }

  boolean isSelected() {
    return active;
  }

  ArrayList<Drawable> getAllObjs() {
    return objs;
  }

  void updateSelected() {
    togglePressed();
  }
  
  void setPos(int x, int y){
    this.x = x;
    this.y = y;
  }
  void setMethod(Method m) {
    call = m;
  }

  void runMethod() {
    if (call!=null) {
      try {
        call.invoke(methodBank);
      } 
      catch(Exception e) {
      }
    }
  }
  String keyUpdate(){
    return "";
  }
  void rename(String n){
   name =  n;
  }
  void setActive(){
   for(Tab tab : allTabs){
    tab.active = false; 
   }
   active = true;
  }
}
