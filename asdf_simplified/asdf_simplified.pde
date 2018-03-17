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

String alphabet = "abc";

String wordstart = "name";
String wordend = "second";

int[] alphaindex = int( alphabet.toCharArray() );
int[] letterstart = int( wordstart.toCharArray() );
int[] letterend = int( wordend.toCharArray() );

// First of first is "n" in "name"
int[] firstletterx = new int[letterstart.length];
int[] firstlettery = new int[letterstart.length];

// First of last is "s" in "second"
int[] lastletterx = new int[letterend.length];
int[] lastlettery = new int[letterend.length];


int row = 0;
int rowdebug = 4;
int column = 0;

boolean saved = false;

void setup() {
  img = loadImage(imgFileName+"."+fileType);
  println("Length1",letterstart.length,"Length2",letterend.length);
  
  /* create arrays to store X and Y coordinates
  int[] xaxis = new int[img.width];
  int[] yaxis = new int[img.height];
  
   for (int xa = 0; xa < xaxis.length; xa = xa+1) {
     xaxis[xa] = xa;
    } */
  
  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);
  
  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);
  
  
}

void draw() {
    /*
      // loop through rows
      while(row < img.height-1) {
        if(row < rowdebug){println("############################# Sorting Row " + row);};
        img.loadPixels(); 
        sortRow();
        row++;
        img.updatePixels();
      } // Endwhile */

      /* Loop through each letter pair and get XY */
      for(int l = 0; l < firstletterx.length; l = l+1) {
      char c = char(letterstart[l]); 
      char d = char(letterend[l]); 
      println("----------------------- Sorting for letter pair "+c+" and "+d+"----------");

        // ROUND((((code(B7)-code("a"))+1)/26)*$H$56)
      int startcharindex = (letterstart[l] - alphaindex[1])+1;
          println("char index is: ",startcharindex);
      float divider = 26.0;    
      float startcharmulti = startcharindex / divider;
          println("char multi is: ",startcharmulti);

      int charstartx = 1;
      int charstarty = round(startcharmulti * (img.height))+1;
          println("X sort postion start for ("+c+") is: ",charstartx);
          println("Y sort postion start for ("+c+") is: ",charstarty);
          
      int endcharindex = (letterend[l] - alphaindex[1])+1;
      float endcharmulti = endcharindex / divider;

      int charendx = round(endcharmulti * (img.width))+1;
      int charendy = charstarty;
          println("X sort postion end for ("+d+") is: ",charendx);
          println("Y sort postion end for ("+d+") is: ",charendy);
          
        img.loadPixels(); 
        println("Calliing sortrow with ",charstartx,charstarty,charendx,charendy);
        sortRow(charstartx,charstarty,charendx,charendy);
        img.updatePixels();
          
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
        
        // where to start sorting
        int x = sx + (sy * img.width);
        println("Start pixel address is "+x);
        
        // where to stop sorting
        int xend = ex + (ey * img.width);
        println("End pixel address is "+xend);
        
         
    // if(x < 0) break;
    
    int sortLength = xend-x;
    println("Sort length is "+sortLength);
    
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
                    println("sorted pixel color for ",x+i," is ",c2); //hex(sorted[i])
                  }
       
    x = xend+1;
  
} // end sort
    
