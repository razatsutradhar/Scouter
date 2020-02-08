class TextBox implements Drawable {
  int x;
  int y;
  int w = -1;
  int h = -1;
  boolean isShown;
  String text;
  color c;
  boolean isBox = false;
  Method call;

  TextBox(String text, int x, int y, int w, int h, color c) {
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

  void show(boolean isShown) {
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

  void setText(String text) {
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
