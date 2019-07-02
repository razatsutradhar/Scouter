interface Drawable{
 void show(boolean isShown); 
 
 void updateSelected();
 
 boolean isSelected();
 
 String keyUpdate();
 
 void setPos(int x, int y);
 
 void setMethod(Method m);
 
 void runMethod();
}
