///////////////////////////////////////////
//////////////////////////////////////////
// Supershapes 3D
//
// Visualization of three dimensional super shapes
///////////////////////////////////////

int sizeFactor = 200;
int detail = 200;

int t = 0;

float a = 1;
float b = 1;
float m = 7;
float n11 = 0.2;
float n12 = 1.7;
float n13 = 1.7;

float a2 = 1;
float b2 = 1;
float m2 = 7;
float n21 = 0.2;
float n22 = 1.7;
float n23 = 1.7;

float a3 = 1;
float b3 = 1;
float m3 = 5;
float n31 = 0.1;
float n32 = 1.7;
float n33 = 1.7;

float a4 = 1;
float b4 = 1;
float m4 = 1;
float n41 = 0.3;
float n42 = 0.5;
float n43 = 0.5;

void setup() {
  background(0);
  size(600, 600, P3D);
  noStroke();
  fill(255, 0, 0);
}

void draw() {
  background(230);
  lights();
  translate(width/2, height/2);
  rotateZ(radians(t*0.4));
  rotateY(radians(t*0.4));
  
  // in first step just save all points of sphere in vector; manipulate in second step
  PVector[][] points = new PVector[detail+1][detail+1];
  
  for (int i=0; i<detail+1; i++) {
    float lat = map(i, 0, detail, HALF_PI, -HALF_PI);
    for (int j=0; j<detail+1; j++) {
      float lon = map(j, 0, detail, -PI, PI);
      
      // calculate supershape radii
      float changeFac = t*0.01;
      sizeFactor = 30;
      float aShape1 = map(sin(changeFac), 0, 1, a, a3);
      float bShape1 = map(sin(changeFac), 0, 1, b, b3);
      float mShape1 = map(sin(changeFac), 0, 1, m, m3);
      float n1Shape1 = map(sin(changeFac), 0, 1, n11, n31);
      float n2Shape1 = map(sin(changeFac), 0, 1, n12, n32);
      float n3Shape1 = map(sin(changeFac), 0, 1, n13, n33);
      
      float aShape2 = map(sin(changeFac), 0, 1, a2, a4);
      float bShape2 = map(sin(changeFac), 0, 1, b2, b4);
      float mShape2 = map(sin(changeFac), 0, 1, m2, m4);
      float n1Shape2 = map(sin(changeFac), 0, 1, n21, n41);
      float n2Shape2 = map(sin(changeFac), 0, 1, n22, n42);
      float n3Shape2 = map(sin(changeFac), 0, 1, n23, n43);
      
      float r1 = supershape(lon, aShape1, bShape1, mShape1, n1Shape1, n2Shape1, n3Shape1);
      float r2 = supershape(lat, aShape2, bShape2, mShape2, n1Shape2, n2Shape2, n3Shape2);
      
      
      float x = sizeFactor * r1 * cos(lon) * r2 * cos(lat);
      float y = sizeFactor * r1 * sin(lon) *r2 * cos(lat);
      float z = sizeFactor * r2 * sin(lat);
      
      points[i][j] = new PVector(x, y, z);
    }
  }
  
  // put points together for 3D shape
  PShape sphere = createShape(GROUP);
  for (int i=0; i<detail; i++) {
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);

    for (int j=0; j<detail+1; j++) {
      PVector v1 = points[i][j];
      PVector v2 = points[i+1][j];
      fill(random(255), 110, 255);
      strip.vertex(v1.x, v1.y, v1.z);
      strip.vertex(v2.x, v2.y, v2.z);
    }
    strip.endShape();
    sphere.addChild(strip);
  }

  shape(sphere);
  
  
  // add a noise overlay
  loadPixels();
  colorMode(RGB);
  for (int i=0; i<pixels.length; i++) {
    float briFac = random(0.7, 1);
    pixels[i] = color(red(pixels[i])*briFac, green(pixels[i])*briFac, blue(pixels[i])*briFac);
  }
  updatePixels();
  colorMode(HSB);
  
  
  // prepare the next frame
  t++;
}



float supershape(float theta, float a, float b, float m, float n1, float n2, float n3) {
  // functions are located here: http://paulbourke.net/geometry/supershape/
  float part1 = cos(m*theta/4);
  part1 = 1/a * part1;
  part1 = abs(part1);
  part1 = pow(part1, n2);
  
  float part2 = sin(m*theta/4);
  part2 = 1/b * part2;
  part2 = abs(part2);
  part2 = pow(part2, n3);
  
  float r = pow(part1 + part2, -1/n1);
  
  return r;
}