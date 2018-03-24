/*

 ASDF Pixel Sort
 Kim Asendorf | 2010 | kimasendorf.com
 
 sorting modes
 
 0 = black
 1 = brightness
 2 = white
 
 */

int mode = 3;

// image path is relative to sketch directory
PImage img;  
String imgFileName = "800x600";
String fileType = "jpg";

int loops = 1;

// threshold values to determine sorting start and end pixels
int blackValue = -10000000; // original: -16000000
int brightnessValue = 30;
int whiteValue = -13000000;

// declare letter and index values and increment value
int letterx = 0;
int lettery = 0;
int increment = 20;
String rendermode = "lefttoright";
String alphabet = "abc";
String word1 = "dog";
String word2 = "second";
String masterword;
String slaveword;

int[] word1chars = int( word1.toCharArray() );
int[] word2chars = int( word2.toCharArray() );
int[] alphaindex = int( alphabet.toCharArray() );

int[] lettermaster;
int[] letterslave;

int[] firstletterx;
int[] firstlettery;

int[] lastletterx;
int[] lastlettery;

int row = 0;
int rowdebug = 4;
int column = 0;

boolean saved = false;

void setup() {
  
  if(word1chars.length > word2chars.length){masterword = word2;slaveword=word1;rendermode = "righttoleft";} else {masterword = word1;slaveword = word2;rendermode = "lefttoright";};
  
  lettermaster = int( masterword.toCharArray() );
  letterslave= int( slaveword.toCharArray() );
  
  // First of first (eg: "n" in "name")
  firstletterx = new int[lettermaster.length];
  firstlettery = new int[lettermaster.length];
  
  // First of last is (eg: "s" in "second")
  lastletterx = new int[letterslave.length*increment];
  lastlettery = new int[letterslave.length*increment];

  img = loadImage(imgFileName+"."+fileType);
  println("Length1",lettermaster.length,"Length2",letterslave.length);
  
  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);
  
  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);
  
  
}

void draw() {
  
            /* Loop through each letter pair and get XY */
            for(int l = 0; l < firstletterx.length; l = l+1) {
            char c = char(lettermaster[l]); 
            char d = char(letterslave[l]); 
            println("----------------------- Sorting for letter pair.. master: "+c+" and slave: "+d+"----------");
      
            // ROUND((((code(B7)-code("a"))+1)/26)*$H$56)
            int startcharindex = (lettermaster[l] - alphaindex[1])+1;  // get position in alphabet
                //println("char index is: ",startcharindex);
            float divider = 26.0;    
            float startcharmulti = startcharindex / divider;
                //println("char multi is: ",startcharmulti);
            int charstartx = 1;
            if(rendermode == "righttoleft"){charstartx = img.width-1;};
            int charstarty = round(startcharmulti * (img.height))+1;
                //println("X sort postion start for ("+c+") is: ",charstartx);
                //println("Y sort postion start for ("+c+") is: ",charstarty);
                
            int endcharindex = (letterslave[l] - alphaindex[1])+1;
            float endcharmulti = endcharindex / divider;
      
            int charendx = round(endcharmulti * (img.width))+1;
            int charendy = charstarty;
                // println("X sort postion end for ("+d+") is: ",charendx);
                // println("Y sort postion end for ("+d+") is: ",charendy);
                
                for(int r = 0; r < increment; r = r+1) {
                  img.loadPixels(); 
                  //if(charendx > img.width-1) {charendx = img.width-1;};
                  println("Calliing sortrow with ",charstartx,charstarty,charendx,charendy);
                  sortRow(charstartx,charstarty,charendx,charendy);
                  img.updatePixels();
                  if(charstarty > img.height-1) {charstarty = img.height-1;} else {charstarty = charstarty + 1;};
                  if(charendy > img.height-1) {charendy = img.height-1;} else {charendy = charendy + 1;};
                  
                  // charendx = charendx - int(random(increment));
                }
                
            } //endfor
 
    


    // load updated image onto surface and scale to fit the display width,height
    image(img, 0, 0, width, height);
    
    if(!saved && frameCount >= loops) {
      
    // save img
      img.save(imgFileName+"_"+mode+".png");
    
      saved = true;
      println("Saved "+frameCount+" Frame(s)");
      
      // exiting here can interrupt file save, wait for user to trigger exit
      println("Click or press any key to exit...");
       
     } // Endif
     
     noLoop();
    
} // Enddraw


  void sortRow(int sx, int sy, int ex, int ey) {
    
        // current row for letter pair
        int y = sy;
        int x;
        int xend;
        // where to start sorting
        if(sx > 1 )  // test if x coordinate is on the left or right
          {
              x = ex + (ey * img.width); // Get pixel cordinate from starting(x,Y) 
              //println("Start pixel address is "+x);
              
              // where to stop sorting
              xend = sx + (sy * img.width); // Get pixel cordinate from ending(x,Y)
              //println("End pixel address is "+xend);
              if(x > xend){};
         }
         else 
          {
              x = sx + (sy * img.width); // Get pixel cordinate from starting(x,Y)
              //println("Start pixel address is "+x);
              
              // where to stop sorting
              xend = ex + (ey * img.width); // Get pixel cordinate from ending(x,Y)
              //println("End pixel address is "+xend);
             
         };
         
    // if(x < 0) break;
    
    int sortLength = xend-x;
    //println("Sort length is "+sortLength);
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    int[] unsortedpixels = new int[sortLength];
    int[] sortedpixels = new int[sortLength];
    
                  for(int i=0; i<sortLength; i++) {
                    unsorted[i] = img.pixels[x + i];
                    unsortedpixels[i] = x + i;
                  }
    
                  sorted = sort(unsorted);
                  sortedpixels = sort(unsortedpixels);
                  
                  for(int i=0; i<sortLength; i++) {
                    color c2 = #FF00FF;
                    img.pixels[x + i] = c2; //sorted[i];      
                    // println("sorted pixel color for ",x+i," is ",c2); //hex(sorted[i])
                  }
       
    x = xend+1;
  
} // end sort
    
