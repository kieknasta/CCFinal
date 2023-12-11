//------------------------------

class Shape {
  PShape obj;
  PImage tex;
  PVector min, max;
  String name;
  PShape bbox;
  PVector vPos;
  float bbs;
  
  Shape(PShape obj,String name){
    bbs = 100.0f;
    this.obj = obj;
    this.name = name;
    calcBBox();
    println("Shape "+name+"min: "+min+" max: "+max);
    //createBBox();
  }
  
  void setVPos(float x, float y) {
    vPos = new PVector(x, y, 0.0);
    min = PVector.sub(vPos, new PVector(bbs/2, bbs/2, 0.0));  
    max = PVector.add(vPos, new PVector(bbs/2, bbs/2, 0.0));
  }
  
  void applyTexture(PImage tex) {
    for (int j = 0; j < obj.getChildCount(); j++) {
      PShape child = obj.getChild(j);
      child.setTexture(tex);
    }
  }
  
  void drawAt(float x, float y) {
    shape(obj, x, y);
    //stroke(255, 0, 0);
    //noFill();
    //shape(bbox, x, y);
  }
  
  void draw() {
    drawAt(vPos.x, vPos.y);
  }
  
  void scale(float f) {
    obj.scale(f);
    println("Sh "+name+" min: "+min + " max: "+max);  
  }  
  
  boolean isInside(float mouseX, float mouseY, float w, float h) {
    PVector mouseVec = new PVector(mouseX, mouseY, 0);
    PVector pt = PVector.sub(mouseVec, new PVector(w/2, h/2, 0));
    PVector maxV = PVector.add(vPos, new PVector(bbs/2, bbs/2, 0));
    PVector minV = PVector.sub(vPos, new PVector(bbs/2, bbs/2, 0));
    //PVector minS = PVector.sub(minV, new PVector(w/2, h/2, 0));
    //PVector maxS = PVector.sub(maxV, new PVector(w/2, h/2, 0));
    println("VPos: "+vPos);
    println("Test "+pt+" min: "+minV+" max: "+maxV);
    return pt.x >= minV.x && pt.x <= maxV.x && pt.y >= minV.y && pt.y <= maxV.y;
  }
  
  void calcBBox() {
    min = new PVector(Float.MAX_VALUE, Float.MAX_VALUE, Float.MAX_VALUE);
    max = new PVector(-Float.MAX_VALUE, -Float.MAX_VALUE, -Float.MAX_VALUE);
    for (int j = 0; j < obj.getChildCount(); j++) {
      PShape child = obj.getChild(j);
      for (int i = 0; i < child.getVertexCount(); i++) {
          PVector v = child.getVertex(i);
          min.x = min(min.x, v.x);
          min.y = min(min.y, v.y);
          min.z = min(min.z, v.z);
          
          max.x = max(max.x, v.x);
          max.y = max(max.y, v.y);
          max.z = max(max.z, v.z);
        }
      }
   }
   
   void createBBox() {
     bbox = createShape();
     bbox.beginShape(QUADS);
    
      // Define vertices of the bounding box
      bbox.vertex(min.x, min.y, min.z);
      bbox.vertex(max.x, min.y, min.z);
      bbox.vertex(max.x, max.y, min.z);
      bbox.vertex(min.x, max.y, min.z);
      // Repeat for each face of the bounding box
      
      bbox.endShape();
   }
}

class TextureDescr
{
  String name;
  String path;
  
  TextureDescr(String name, String path)
  {
    this.name = name;
    this.path = path;
  }
}

ArrayList<String> sPaths = new ArrayList<String>();
ArrayList<TextureDescr> tPaths = new ArrayList<TextureDescr>();
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<Shape> t = new ArrayList<Shape>();

void setup() {
  tPaths.add(new TextureDescr("news", "data/newspaper-square.jpg"));
  tPaths.add(new TextureDescr("flowers", "data/drawing-square.jpg"));
  tPaths.add(new TextureDescr("photo", "data/photo-square.jpg"));
  sPaths.add("data/mug.obj");
  sPaths.add("data/umbrella.obj");
  sPaths.add("data/shirt.obj");
  PImage zeroTex = loadImage("data/2x2.jpg");  
  size(1000, 1000, P3D);
  float w = 1000;
  float h = 1000;
  for (int i=0;i<tPaths.size();++i) {
    PShape plane = loadShape("data/plane.obj");
    plane.scale(200);  
    Shape sh = new Shape(plane, tPaths.get(i).name);
    t.add(sh);
    sh.applyTexture(loadImage(tPaths.get(i).path));  
    sh.setVPos((float)(i*w/3.0) - w/3.0, -h/5.0);
  }
  for (int i=0;i<sPaths.size(); ++i) {
    PShape obj = loadShape(sPaths.get(i));
    Shape sh = new Shape(obj, sPaths.get(i));
    sh.scale(20);
    shapes.add(sh);    
    sh.setVPos((float)(i*w/3.0) - w/3.0, h/5.0);
    //applyTexture(obj, zeroTex);
  }
}

void draw() {
 background(100);
 lights();
 translate(width/2, height/2);
  //rotateX(QUARTER_PI);
  //rotateY(frameCount * 0.01);
  
  for (int i=0;i<shapes.size();++i) {
    t.get(i).draw();
    shapes.get(i).draw();
  }
}

void keyReleased() {
  if (key == 'g') {
    println("The 'a' key was released.");
  }
  // You can add more conditions for other keys here
}

void mousePressed() {
  
  //println("Dir "+dir);
  for (int i=0;i<t.size();++i) {
    if (t.get(i).isInside(mouseX, mouseY, width, height)) {
      println("Click to "+t.get(i).name);
    }
  }
  /*for (int i=0;i<shapes.size(); ++i) {
    if (shapes.get(i).isInside(mouseX, mouseY, width, height)) {
      println("Click to "+shapes.get(i).name);
    }
  }*/
  // Now 'dir' is the direction of the ray. 
  // You can use it to check for intersections with objects in your scene.
}
