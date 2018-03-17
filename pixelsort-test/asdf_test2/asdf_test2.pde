
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
String wordx = "second";
String wordy = "name";
int[] alphaindex = int( alphabet.toCharArray() );
int[] lettersx = int( wordx.toCharArray() );
int[] lettersy = int( wordy.toCharArray() );

int[] firstletteraddress = new int[lettersx.length];
int[] lastletteraddress = new int[lettersx.length];


int row = 0;
int rowdebug = 30;
int column = 0;

boolean saved = false;

void setup() {
  img = loadImage(imgFileName+"."+fileType);
  println("Length1",lettersx.length,"Length2",lettersy.length);
  
  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);
  
  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);
  
  // Display information about the word on the left Y axis
    for (int i = 0; i < lettersy.length; i = i+1) {
    
      int charindex = (lettersy[i] - alphaindex[1])+2;
      int charshift = charindex + 2;
          // println("char index is: ",charshift);
          // println("width is: ",img.width);
          //  println("multiplier is: ",img.width + increment);
       int colpixel = charshift * (img.width + increment);
          // println(charshift," * ",img.width + increment," = ",colpixel);
       firstletteraddress[i] = colpixel; // e.g. "S" (13780)
       println("Starting Address is: ",firstletteraddress[i]);
       println("Starting X is: ",firstletteraddress[i] / img.width);
       println("Starting Y is: ",firstletteraddress[i] % img.width);

       
      
       int ycharindex = (lettersx[i] - alphaindex[1])+2;
       int ycharshift = ycharindex + 14;
          // println("y char index is: ",ycharshift);
          // println("width is: ",img.width);
          // println("multiplier is: ",increment);
       int endpixeladd = ycharshift * increment;
          // println(ycharshift," * ",increment," = ",endpixeladd);

       
       lastletteraddress[i] = colpixel + endpixeladd; // e.g. "N" (13120)
       println("final address is: ",lastletteraddress[i]);
       println("Final X is: ",lastletteraddress[i] / img.width);
       println("Final Y is: ",lastletteraddress[i] % img.width);

   
    
    }
  
}


void draw() {
  
 /* // loop through columns
  while(column < img.width-1) {
    println("Sorting Column " + column);
    img.loadPixels(); 
    sortColumn();
    column++;
    img.updatePixels();
  } */
  
  // loop through rows
  while(row < img.height-1) {
    if(row < rowdebug){println("############################# Sorting Row " + row);};
    img.loadPixels(); 
    sortRow();
    row++;
    img.updatePixels();
  }
  
  // load updated image onto surface and scale to fit the display width,height
  image(img, 0, 0, width, height);
  
  if(!saved && frameCount >= loops) {
    
  // save img
    img.save(imgFileName+"_"+mode+".png");
  
    saved = true;
    println("Saved "+frameCount+" Frame(s)");
    
    // exiting here can interrupt file save, wait for user to trigger exit
    println("Click or press any key to exit...");
  }
}

void keyPressed() {
  if(saved)
  {
    System.exit(0);
  }
}

void mouseClicked() {
  if(saved)
  {
    System.exit(0);
  }
}

void sortRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  /* OLD LOGIC TO GET SORTING RANGES */
  for(int l = 0; l < firstletteraddress.length; l = l+1) {
    switch(mode) {
      case 0:
        x = getFirstNotBlackX(x, y);
        xend = getNextBlackX(x, y);
        break;
      case 1:
        x = getFirstBrightX(x, y);
        xend = getNextDarkX(x, y);
        break;
      case 2:
        x = getFirstNotWhiteX(x, y);
        xend = getNextWhiteX(x, y);
        break;
    case 3:
        // if(row < rowdebug){println("Checking X Coordinate: ",y*width+x);};
        x = getFirstLetterX(x, y, l);
        if(row < rowdebug){println("x=",x);};
        xend = getLastLetterX(x, y, l);
        if(row < rowdebug){println("xend=",xend);};
        break;
      default:
        break;
    }
  
    
    if(x < 0) break;
    
    int sortLength = xend-x; //e.g. "S" (13780) - "N" (13120) = 660 
    if(row < rowdebug){println("sortLength is",sortLength);};
    color[] unsorted = new color[sortLength]; //e.g.  (660 = hex 000294, rgb(0,2,148), dark blue)
    color[] sorted = new color[sortLength]; //e.g.  (660 = hex 000294, rgb(0,2,148), dark blue)
    
    for(int i=0; i<sortLength; i++) { //e.g.  loop 660 times
      unsorted[i] = img.pixels[x + i + y * img.width]; // get colors of all pixels in range
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      img.pixels[x + i + y * img.width] = sorted[i];      
    }
    
    x = xend+1; 
  }
}

/*
void sortColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
    switch(mode) {
      case 0:
        println("Fuck you!");
        break;
      case 1:
        y = getFirstBrightY(x, y);
        yend = getNextDarkY(x, y);
        break;
      case 2:
        y = getFirstNotWhiteY(x, y);
        yend = getNextWhiteY(x, y);
        break;
      default:
        break;
    } 
  
      
    if(y < 0) break;
    
    int sortLength = yend-y;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }
    
    y = yend+1;
  }
}
*/

// letter x
int getFirstLetterX(int x, int y, int l) {
  
  while((x + y * img.width) < firstletteraddress[l]) {
    x++;
    if(x >= img.width)
      return -1;
  }
  
  return x;
}

int getLastLetterX(int _x, int _y, int _l) {
  int x = _x+1;
  int y = _y;
  int l = _l;
  
  while((x + y * img.width) < lastletteraddress[l]) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

// black x
int getFirstNotBlackX(int x, int y) {
  
  while(img.pixels[x + y * img.width] < blackValue) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  
  return x;
}

int getNextBlackX(int x, int y) {
  x++;
  
  while(img.pixels[x + y * img.width] > blackValue) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  
  return x-1;
}

// brightness x
int getFirstBrightX(int x, int y) {
  
  while(brightness(img.pixels[x + y * img.width]) < brightnessValue) {
    x++;
    if(x >= img.width)
      return -1;
  }
  
  return x;
}

int getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  
  while(brightness(img.pixels[x + y * img.width]) > brightnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

// white x
int getFirstNotWhiteX(int x, int y) {

  while(img.pixels[x + y * img.width] > whiteValue) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;

  while(img.pixels[x + y * img.width] < whiteValue) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  return x-1;
}

int getNextBlackY(int x, int y) {
  y++;

  if(y < img.height) {
    while(img.pixels[x + y * img.width] > blackValue) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  
  return y-1;
}

// brightness y
int getFirstBrightY(int x, int y) {

  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) < brightnessValue) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextDarkY(int x, int y) {
  y++;

  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) > brightnessValue) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  return y-1;
}

// white y
int getFirstNotWhiteY(int x, int y) {

  if(y < img.height) {
    while(img.pixels[x + y * img.width] > whiteValue) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextWhiteY(int x, int y) {
  y++;
  
  if(y < img.height) {
    while(img.pixels[x + y * img.width] < whiteValue) {
      y++;
      if(y >= img.height) 
        return img.height-1;
    }
  }
  
  return y-1;
}