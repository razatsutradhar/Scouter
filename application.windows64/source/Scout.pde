class Scout{
 File scouterPath;
 Scout(File F){
 }
 
 ArrayList<File> getNewData(File path){
   currentFiles.clear();
   for(File f : currentLocation.listFiles()){
     currentFiles.add(f);
   }
   scouterPath = path;
   ArrayList<File> newData = new ArrayList();
   for(File f : scouterPath.listFiles()){
     if(!currentFiles.contains(f)){
       new File("/../"+f.getName()).mkdir();
     }
   }
   
   return newData;
 }
}

public void scouterPhoneSelected(File selection){
  allScouts.add(new Scout(selection));
  println(selection.getAbsolutePath());
  //if(File(currentLocation+"/"))
}
