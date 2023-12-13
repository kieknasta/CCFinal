//------------------------------
import java.util.HashSet;
import java.util.Set;
import java.util.Comparator;
import java.util.Collections;

class Shape {
  PShape obj;
  PImage tex;
  PVector min, max;
  String name;
  PShape bbox;
  PVector vPos;
  float bbs;
  float yaw;
  
  Shape(PShape obj,String name){
    bbs = 200.0f;
    this.obj = obj;
    this.name = name;
    calcBBox();
    println("Shape "+name+"min: "+min+" max: "+max);
    yaw = 0.0f;
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
    //rotateX(pitch);
    pushMatrix();
    translate(vPos.x, vPos.y);
    rotateY(yaw);
    translate(-vPos.x, -vPos.y);
    shape(obj, x, y);
    popMatrix();
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

class ObjDescr
{
  String name;
  String path;
  
  ObjDescr(String name, String path)
  {
    this.name = name;
    this.path = path;
  }
}

class Scene {

  ArrayList<ObjDescr> sPaths = new ArrayList<ObjDescr>();
  ArrayList<ObjDescr> tPaths = new ArrayList<ObjDescr>();
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  ArrayList<Shape> t = new ArrayList<Shape>();
  Set<String> selT = new HashSet<>();
  Shape selShape = null;
  Shape cShape = null;
  ArrayList<String> objFiles = new ArrayList<String>();
  boolean mousePressed;
  float pitch, yaw;
  float lastMX, lastMY;
  float w, h;
  String ttCurr;
  String ttAll;
  
  void Create() {
    tPaths.add(new ObjDescr("news", "data/newspaper-square.jpg"));
    tPaths.add(new ObjDescr("flowers", "data/drawing-square.jpg"));
    tPaths.add(new ObjDescr("photo", "data/photo-square.jpg"));
    sPaths.add(new ObjDescr("mug", "data/mug.obj"));
    sPaths.add(new ObjDescr("umbrella", "data/umbrella.obj"));
    sPaths.add(new ObjDescr("shirt", "data/shirt.obj"));
    PImage zeroTex = loadImage("data/2x2.jpg");  
    
    w = 1000.f;
    h = 1000.f;
    for (int i=0;i<tPaths.size();++i) {
      PShape plane = loadShape("data/plane.obj");
      plane.scale(200);  
      Shape sh = new Shape(plane, tPaths.get(i).name);
      t.add(sh);
      sh.applyTexture(loadImage(tPaths.get(i).path));  
      sh.setVPos((float)(i*w/3.0) - w/3.0, -h/5.0);
    }
    for (int i=0;i<sPaths.size(); ++i) {
      PShape obj = loadShape(sPaths.get(i).path);
      Shape sh = new Shape(obj, sPaths.get(i).name);
      sh.scale(20);
      shapes.add(sh);    
      sh.setVPos((float)(i*w/3.0) - w/3.0, h/5.0);
      //applyTexture(obj, zeroTex);
    }
    loadObjFiles();
    mousePressed = false;
    pitch = 0.0f;
    yaw = 0.0f;
    ttAll = "Select one shape and up to three textures and press 'g' key";
    ttCurr = "";
  }
  
  void loadObjFiles() {
    File folder = new File(dataPath(""));
    File[] listOfFiles = folder.listFiles();
    for (File file : listOfFiles) {
    if (file.isFile()) {
      println("File: " + file.getName());
      if (file.getName().endsWith(".obj")) {
        objFiles.add(file.getName());
      }
    } else if (file.isDirectory()) {
      println("Directory: " + file.getName());
    }
    }
    println("Loaded " +objFiles.size()+" models");
  }
  
  void draw(float frameCount) {
    directionalLight(255, 255, 255, 0, 0, -1);
    if (ttCurr.length()<ttAll.length() && frameCount % 5 == 0) {
      ttCurr = ttCurr + ttAll.charAt(ttCurr.length());
    }
    if (cShape != null)
    {
      rotateX(pitch);
      rotateY(yaw);
      cShape.draw();
      //rotateX(-pitch);
      //rotateY(-yaw);
      text(ttCurr, -w*3.0f/8.0f, -h*3.0f/8.0f);
    } 
    else 
    {
      if  (selShape != null) {
        selShape.yaw = 0.01f * frameCount;
      }
      for (int i=0;i<t.size();++i) {
        t.get(i).yaw = selT.contains(t.get(i).name) ? 0.01f * frameCount : 0.0f;
      }
      for (int i=0;i<shapes.size();++i) {
        t.get(i).draw();
        shapes.get(i).draw();
      }
      
      fill(255);
      //hint(DISABLE_DEPTH_TEST);
      text(ttCurr, -w*3.0f/8.0f, -h*3.0f/8.0f);
    }
  }
  
  void clear() {
    cShape = null;
    selT.clear();
    selShape = null;
    pitch = 0.0f;
    yaw = 0.0f;
    ttAll = "Select one shape and up to three textures and press 'g' key";
    ttCurr = "";
  }
  
  
  ArrayList<String> generateAllNamesR(Set<String> s) {
    ArrayList<String> r = new ArrayList<String>();
    if (s.size() == 0)
       return r;
    if (s.size() == 1)
      for (String str : s)
      {  
        r.add(str);
        return r;
      }
    for (String str : s) {
      Set<String> newS = new HashSet(s);
      newS.remove(str);
      ArrayList<String> se = generateAllNamesR(newS);
      for (String t : se) {
        r.add(str+"-"+t);
      }
    }
    return r;
  }
  
  void generateCollage() {
    
    ArrayList<String> allSuff = generateAllNamesR(selT);
    Comparator<String> byLength = new Comparator<String>() {
    public int compare(String s1, String s2) {
      return Integer.compare(s2.length(), s1.length());
    }
  };
  Collections.sort(allSuff, byLength);
    println("Suff generated "+allSuff.size());
    for (String suff : allSuff) {
      println("  "+suff);
    }
    String cfName = "";
    for (String suff : allSuff) {
      String objName = selShape.name + "-" + suff + ".obj";  
      println("Cheking file name "+objName);
      if (objFiles.indexOf(objName) >= 0) {
        cfName = objName;
        break;
      }
    }
   
    if (cfName == "")
    {
      println("Can't create collage from "+selT.size()+ " textures"); 
      return;
    }
    println("Showing collage "+cfName+ " from "+selT.size()+" textures");
    PShape obj = loadShape(cfName);
    cShape = new Shape(obj, "Collage");
    cShape.scale(50);
    cShape.setVPos(0.0, 0.0);  
    ttAll = "Drag the mouse to rotate or press 'c' key to go back";
    ttCurr = "";  
  }
  
  void OnMousePressed(float mouseX, float mouseY, float w, float h) {
    for (int i=0;i<t.size();++i) {
      if (t.get(i).isInside(mouseX, mouseY, w, h)) {
        println("Click to "+t.get(i).name);
        if (selT.contains(t.get(i).name))
          selT.remove(t.get(i).name);
        else
          selT.add(t.get(i).name);
      }
    }
    for (int i=0;i<shapes.size(); ++i) {
      if (shapes.get(i).isInside(mouseX, mouseY, w, h)) {
        println("Click to "+shapes.get(i).name);
        selShape = shapes.get(i);  
      }
    }
    mousePressed = true;
    lastMX = mouseX;
    lastMY = mouseY;
  }
  
  void OnMouseReleased(float mouseX, float mouseY, float w, float h) {
    mousePressed = false;
  }
  
  void OnMouseMoved(float mouseX, float mouseY) {
    if  (!mousePressed || cShape == null) {
      return;
    }
    println("w:"+w+" h: "+h);
    float dX = (mouseX - lastMX)/w;
    float dY = (mouseY - lastMY)/h;
    println("Dx:"+dX+" Dy: "+dY);
    float rR = 1.f;
    pitch -= dY/rR;
    yaw += dX/rR;
    println("Current pitch: "+pitch+" yaw: "+yaw);
    lastMX = mouseX;
    lastMY = mouseY;
  }
  
}

Scene scene = new Scene();

void setup() {
  size(1000, 1000, P3D);
  textSize(32);
  scene.Create();  
}

void draw() {
 background(0);
 lights();
 translate(width/2, height/2);
  //rotateX(QUARTER_PI);
  //rotateY(frameCount * 0.01);
 scene.draw(frameCount);  
}



void keyReleased() {
  if (key == 'g') {
    println("The 'g' key was released.");
    scene.generateCollage();   
  }
  if (key == 'c') {
    println("The 'c' key was released.");
    scene.clear();   
  }
  // You can add more conditions for other keys here
}

void mousePressed() {
  
  //println("Dir "+dir);
  scene.OnMousePressed(mouseX, mouseY, width, height);
  // Now 'dir' is the direction of the ray. 
  // You can use it to check for intersections with objects in your scene.
}

void mouseReleased() {
  // Code to execute when the mouse is released
  println("Mouse released");
  scene.OnMouseReleased(mouseX, mouseY, width, height);
}

void mouseMoved() {
  // Code to execute when the mouse is moved
  println("Mouse moved to x: " + mouseX + ", y: " + mouseY);
  scene.OnMouseMoved(mouseX, mouseY);
}

void mouseDragged() {
    scene.OnMouseMoved(mouseX, mouseY);
}
