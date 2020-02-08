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


  String keyUpdate() {
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

  void updateSelected() {
    if (mousePressed)
    if (mouseX > x && mouseX<x+w && mouseY > y && mouseY<y+h) {
      isSelected = true;
    } else {
      isSelected = false;
    }
  }

  String getSearchQuery() {
    return searchQuery;
  }

  void show(boolean isShown) {
    this.isShown = isShown;
    if (isShown) {
      if (isSelected) {
        fill(255);
      } else {
        fill(150);
      }
      rect(x, y, w, h);    
      textSize((int)(h*0.7));

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

  boolean isSelected() {
    return isSelected && isShown;
  }

  void setPos(int x, int y) {
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
}
