//////////////////////////////////////////////////////
/////////////////////////////////////////////////////
// Meteor Strikes 3D
///////////////////////////////////////////////////
// 3D visualization of meteorites of different time periods and where they crashed on earth
// the color represents the time of the crash (from BC to today – from blue to yellow).
//
// Use mouse to rotate earth.
// Press any key to show trajectories of meteorites.
//
// Enjoy.
//////////////////////////////////////////////

// PeasyCam integration for simple mouse interactions
import peasy.*;
PeasyCam cam;

// texture variables
PImage worldMapPNG;
PImage background;
int mapWidth = 1600;
int mapHeight = 800;

// data variables
String meteorCSV[];
String meteorData[][];
int earliest = -600;
int latest = 2012;
float[][] meteorPositions;

// sphere variables
PVector[][] points;
int radius = 200;
int detail = 100;

// save position (based on sphere point calculation) and brightness of all stars in an array
float[][] stars = new float[500][4];


int t = 0;

void setup() {
  background(0);
  size(1280, 800, P3D);
  colorMode(HSB);
  noStroke();
  noFill();

  setupPeasyCam();

  // load images
  worldMapPNG = loadImage("worldmap2.PNG");
  background = loadImage("background.png");

  loadCSV();
  loadMeteors();

  loadStars();
  
  loadSpherePoints();
}

void draw() {
  println(frameRate);
  setup3DCanvas();
  rotateCanvas(t, 0.1);
  
  drawStars();
  
  drawSphere();

  drawMeteors();

  addNoiseOverlay();

  t++;
}

//////////////////////////
// Functions ////////////
////////////////////////

void setupPeasyCam() {
  cam = new PeasyCam(this, 700);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);
}

void loadCSV() {
  meteorCSV = loadStrings("MeteorStrikesDataSet.csv");
  meteorData = new String[meteorCSV.length][6];

  for (int i=0; i<meteorCSV.length; i++) {
    meteorData[i] = meteorCSV[i].split(",");
  }
}

void loadMeteors() {
  meteorPositions = new float[meteorData.length][7];
  for (int i=0; i<meteorData.length; i++) {
    // calculate and save meteors' positions
    float floatingHeight = 5;
    float lon = map(float(meteorData[i][3]), -180, 180, -PI, PI);
    float lat = map(float(meteorData[i][4]), 90, -90, 0, PI);

    float x = (radius + floatingHeight)  * cos(lon) * sin(lat);
    float y = (radius + floatingHeight) * sin(lon) * sin(lat);
    float z = (radius + floatingHeight) * cos(lat);
    
    meteorPositions[i][0] = x;
    meteorPositions[i][1] = y;
    meteorPositions[i][2] = z;
    
    
    // calculate and save meteors' trajectory starting points
    float theta = random(0, PI);
    float gamma = random(0, TWO_PI);
    float r = 4000;

    float xTraj = r * cos(gamma) * sin(theta);
    float yTraj = r * sin(gamma) * sin(theta);
    float zTraj = r * cos(theta);

    meteorPositions[i][3] = xTraj;
    meteorPositions[i][4] = yTraj;
    meteorPositions[i][5] = zTraj;
    
    
    // calculate and save meteors' colors
    // set stroke color based on year of strike
    int year = int(meteorData[i][1]);
    float hue = map(year, earliest+2000, latest, 150, 290);

    // correct color to have less orange
    if (hue > 265 && hue < 280) {
      hue -= 30;
    }
    if (hue>255) {
      hue -= 255;
    }
    meteorPositions[i][6] = hue;
  }    
}

void drawMeteors() {
  float saturation = 160;
  float brightness = 255 ;
  strokeWeight(4);
  
  for (int i=0; i<meteorData.length; i++) {
    float x = meteorPositions[i][0];
    float y = meteorPositions[i][1];
    float z = meteorPositions[i][2];
    float hue = meteorPositions[i][6];
    
    stroke(hue, saturation, brightness);
    point(x, y, z);
    
    if (keyPressed) {
      if (i%2 == 0) {
        // display trajectory lines for each of them
        PVector startVector = new PVector(x, y, z);
        PVector endVector = new PVector(meteorPositions[i][3], meteorPositions[i][4], meteorPositions[i][5]);
        int startFac = 10;
        int endFac = 100;
        strokeWeight(0.1);
        noFill();
        bezier(startVector.x, startVector.y, startVector.z, startVector.x * startFac, startVector.y * startFac, startVector.z * startFac, endVector.x, endVector.y, endVector.z, endVector.x * endFac, endVector.y * endFac, endVector.z * endFac); 
      }
    }
  }
}

void loadStars() {
  // save star positions and brightness in array
  for (int i=0; i<stars.length; i++) {
    float theta = random(0, PI);
    float gamma = random(0, TWO_PI);
    float r = random(1000, 4000);

    float x = r * cos(gamma) * sin(theta);
    float y = r * sin(gamma) * sin(theta);
    float z = r * cos(theta);

    stars[i][0] = x;
    stars[i][1] = y;
    stars[i][2] = z;
    stars[i][3] = random(0.6, 1);
  }
}

void setup3DCanvas() {
  background(background);
  lights();
  rotateX(radians(150));
  rotateY(radians(-40));
}

void rotateCanvas(int t, float factor) {
  // constant rotation
  rotateZ(radians(t*factor));
  rotateY(radians(t*factor));
}

void drawStars() {
  // draw stars over background
  colorMode(RGB);
  for (int i=0; i<stars.length; i++) {
    float briVal = stars[i][2];
    stroke(255*briVal, 255*briVal, 255*briVal);
    strokeWeight(2);
    point(stars[i][0], stars[i][1], stars[i][2]);
  }
  noStroke();
  colorMode(HSB);
}

void loadSpherePoints() {
  // in first step just save all points of sphere in two dimensional vector to separate calculation and display
  points = new PVector[detail+1][detail+1];

  for (int i=0; i<detail+1; i++) {
    float lat = map(i, 0, detail, 0, PI);
    for (int j =0; j<detail+1; j++) {
      float lon = map(j, 0, detail, -PI, PI);
      float x = radius * cos(lon) * sin(lat);
      float y = radius * sin(lon) * sin(lat);
      float z = radius * cos(lat);

      points[i][j] = new PVector(x, y, z);
    }
  }
}

void drawSphere() {
  // put points together for 3D shape
  PShape sphere = createShape(GROUP);
  sphere.beginShape();

  for (int i=0; i<detail; i++) {
    // create each horizontal strip individually and put together as group
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);

    strip.texture(worldMapPNG);
    for (int j=0; j<detail+1; j++) {
      PVector v1 = points[i][j];
      PVector v2 = points[i+1][j];
      strip.vertex(v1.x, v1.y, v1.z, j*mapWidth/detail, i*mapHeight/detail);
      //strip.normal(v1.x, v1.y, v1.z);
      strip.vertex(v2.x, v2.y, v2.z, j*mapWidth/detail, (i+1)*mapHeight/detail);
      //strip.normal(v2.x, v2.y, v2.z);
    }
    strip.endShape();
    sphere.addChild(strip);
  }
  shape(sphere);
}

void addNoiseOverlay() {
  // add a noise overlay
  loadPixels();
  for (int i=0; i<pixels.length; i++) {
    pixels[i] = color(hue(pixels[i]), saturation(pixels[i]), brightness(pixels[i]) * random(0.85, 1));
  }
  updatePixels();
}