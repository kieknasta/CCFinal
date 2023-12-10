//---------------------------------------------------------------------------------moving 2nd umbrella
//PImage img;
//
//void setup() {
//  size(640, 360);
//  img = createImage(230, 230, ARGB);
//  for(int i = 0; i < img.pixels.length; i++) {
//    float a = map(i, 0, img.pixels.length, 255, 0);
//    img.pixels[i] = color(0, 153, 204, a);
//  }
//}
//
//void draw() {
//  background(0);
//  image(img, 90, 80);
//  image(img, mouseX-img.width/2, mouseY-img.height/2);
//}
//-----------------------------------------------------------------------------------heart shape
//smooth();
//noStroke();
//fill(255,0,0);
//beginShape();
//vertex(50, 15);
//bezierVertex(50, -5, 90, 5, 50, 40);
//vertex(50, 15);
//bezierVertex(50, -5, 10, 5, 50, 40);
//endShape();
//--------------------------------------------------------------------------------------umbrella
//PImage umb;
//
//void setup () {
//  PGraphics pg = createGraphics(200, 100);
//  pg.beginDraw();
//  pg.background(0, 0, 0, 0);
//  pg.translate(100, 100);
//  pg.noStroke();
//  pg.fill(255);
//  pg.ellipse(0, 0, 200, 200);
//  pg.fill(0);
//  pg.ellipse(-75, 0, 50, 50);
//  pg.ellipse(-25, 0, 50, 50);
//  pg.ellipse(25, 0, 50, 50);
//  pg.ellipse(75, 0, 50, 50);
//  pg.endDraw();
//  PImage msk = pg.get();
//  umb = get(0,0,200,100);
//  umb.mask(msk);
//  background(100, 40, 150); // Purple
//}
//
//void draw () {
//}
//
//void mousePressed() {
//  image(umb, mouseX-100, mouseY-100);
//}
//------------------------------------------------------------------------------------------cup
//PShape s;  // The PShape object
//
//void setup() {
//  size(1000, 1000);
  // Creating a custom PShape as a square, by
  // specifying a series of vertices.
//  s = createShape();
//  s.beginShape();
// s.fill(0, 0, 255);
//  s.noStroke();
//  s.vertex(0, 0);
//  s.vertex(0, 50);
//  s.vertex(50, 50);
//  s.vertex(50, 0);
//  s.endShape(CLOSE);
//}
//
//void draw() {
//  shape(s, 25, 25);
//}
//----------------------------------------------------------------------------------------upload image
PImage photo;
PImage newspaper;
PImage drawing;

PShape heart;

PShape obj;

void setup() {
  size(1000, 1000, P3D);
  photo = loadImage("photo.jpg");
  newspaper = loadImage("newspaper.jpg");
  drawing = loadImage("drawing.jpg");
  obj = loadShape("data/mug-3-textures.obj");
  obj.scale(50);
  /*for (int i = 0; i < obj.getChildCount(); i++) {
    PShape child = obj.getChild(i);
    child.setTexture(photo);
  }*/
  /*heart = createShape();
  heart.beginShape();
  heart.fill(255, 0, 0);
  heart.noStroke();
  heart.vertex(50, 15);
  heart.bezierVertex(50, -5, 90, 5, 50, 40);
  heart.vertex(50, 15);
  heart.bezierVertex(50, -5, 10, 5, 50, 40);
  heart.endShape(CLOSE);*/
  

}

void draw() {
 background(100);
 lights();
  translate(width/2, height/2);
  //rotateX(QUARTER_PI);
  //rotateY(frameCount * 0.01);
  shape(obj);
}
