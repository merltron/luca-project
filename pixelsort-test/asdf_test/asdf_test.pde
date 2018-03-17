
/*

 ASDF Pixel Sort
 Kim Asendorf | 2010 | kimasendorf.com
 
 sorting modes
 
 0 = black
 1 = brightness
 2 = white
 
 */

int mode = 0; 

// image path is relative to sketch directory
PImage img;  
String imgFileName = "sl_glitch";
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

int row = 0;
int column = 0;

boolean saved = false;

void setup() {
  img = loadImage(imgFileName+"."+fileType);
  
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
   println("Starting Address is: ",colpixel);
   
      int ycharindex = (lettersx[i] - alphaindex[1])+2;
      int ycharshift = ycharindex + 14;
         // println("y char index is: ",ycharshift);
         // println("width is: ",img.width);
         // println("multiplier is: ",increment);
      int endpixeladd = ycharshift * increment;
       // println(ycharshift," * ",increment," = ",endpixeladd);
        println("final address is: ",colpixel + endpixeladd);
  
 /* Display information about the word on the top x axis
     for (int e = 0; e < lettersx.length; e = e+1) {
      int ycharindex = (lettersx[e] - alphaindex[1])+2;
      int ycharshift = ycharindex + 14;
         // println("y char index is: ",ycharshift);
         // println("width is: ",img.width);
         // println("multiplier is: ",increment);
      int endpixeladd = ycharshift * increment;
       // println(ycharshift," * ",increment," = ",endpixeladd);
        println("final address is: ",colpixel + endpixeladd);
    } */
  
}


  
}

// load updated image onto surface and scale to fit the display width,height
void draw() {
  image(img, 0, 0, width, height);
 }