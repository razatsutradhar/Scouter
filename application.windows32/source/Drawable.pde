//////////////////////////////////////////////////////////////////////
/*                   DRAWABLE INTERFACE                             */
/*This interface will be the outline for every object drawn on the  */
/*screen                                                            */
//////////////////////////////////////////////////////////////////////
interface Drawable{
 //draws the object on the screen
 void show(boolean isShown);
 
 //this is what happens when the object is clicked
 void updateSelected();
 
 //this return true/false depending if the object is selected
 boolean isSelected();
 
 //this is the code that runs if the object is selected 
 //and you are typing
 String keyUpdate();
 
 //sets the position on the screen where the object will be drawn
 void setPos(int x, int y);
 
 //sets the method that will run when the object is clicked
 void setMethod(Method m);
 
 //runs the set method for when it is clicked
 void runMethod();
}
