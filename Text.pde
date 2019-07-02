class TextBox implements Drawable {
  int x;
  int y;
  boolean isShown;
  String text;
  Method call;

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

  void show(boolean isShown) {
    this.isShown = isShown;
    if (isShown) {
      fill(255);
      textAlign(LEFT, CENTER);
      text(text, x, y);
      textAlign(CENTER, CENTER);
    }
    runMethod();
  }

  void updateSelected() {
  }

  boolean isSelected() {
    return false;
  }

  String keyUpdate() {
    return "";
  }

  void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void setText(String text){
    this.text = text;
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
}
