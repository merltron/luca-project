/**
 * Image Pixels Index XY
 * 2016-10-26 Processing 2.01
**/
PImage img;
int pi, px, py, pi2;
 
void setup() {
  size(800,600);
  img = loadImage("800x600.jpg");
  stroke(255);
  frameRate(1);
  image(img,0,0);
}  
void draw(){
  // pick random index
  pi = randomPixelIndex(img);
  // xy from index
  px = indexToX( pi, img );
  py = indexToY( pi, img );
  // index from xy
  pi2 = xyToIndex(px, py, img);
 
  // check if reconverted index is equal
  println("i: "+ pi +" "+ (pi==pi2) +"  x: "+ px +" y: "+ py);  
 
  // label pixel with box and xy text
  fill(0,0,0,64);
  rect(px-10, py-10, 20, 20);
  point(px, py);
  translate(px,py);
  fill(128,64,64);
  text(pi+","+px+","+py,12,5); //  text("("+pi+") "+px+","+py,12,5);
}
// choose a random pixel. in P3 might use PImage.pixels[].length
int randomPixelIndex(PImage _img){
  return (int)random(0, _img.width * _img.height);
}
// convert image xy to pixel index
int xyToIndex(int x, int y, PImage img){
  return ( y * img.width ) + x;
}
// convert pixel index to image x
int indexToX(int i, PImage img){
  return ( i % img.width );
}
// convert pixel index to image y
int indexToY(int i, PImage img){
  return ( i / img.width );
}
// could replace indexToX and indexToY
// with one function returning an int[] xy or a PVector