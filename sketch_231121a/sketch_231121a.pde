//------------------------------


ArrayList<String> sPaths = new ArrayList<String>();
ArrayList<PShape> shapes = new ArrayList<PShape>();
PShape plane;

void setup() {
  sPaths.add("data/mug-photo.obj");
  sPaths.add("data/umbrella-flowers.obj");
  sPaths.add("data/shirt-flowers.obj");
  
  size(1000, 1000, P3D);
  plane = loadShape("data/plane.obj");
  plane.scale(50);
  //photo = loadImage("photo.jpg");
  //newspaper = loadImage("newspaper.jpg");
  //drawing = loadImage("drawing.jpg");
  
  for (int i=0;i<sPaths.size(); ++i) {
    PShape obj = loadShape(sPaths.get(i));
    obj.scale(20);
    shapes.add(obj);
  }
  /*for (int i = 0; i < obj.getChildCount(); i++) {
    PShape child = obj.getChild(i);
    child.setTexture(photo);
  }*/
}

void draw() {
 background(100);
 lights();
  translate(width/2, height/2);
  //rotateX(QUARTER_PI);
  //rotateY(frameCount * 0.01);
  shape(plane, - width/3.0, -height/5.0);
  for (int i=0;i<shapes.size();++i) {
    shape(shapes.get(i), (float)(i*width/3.0) - width/3.0, height/5.0);
  }
  
}
