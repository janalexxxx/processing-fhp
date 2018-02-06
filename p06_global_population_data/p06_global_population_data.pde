/////////////////////////////////////////////////////
////////////////////////////////////////////////////
// Visualization of global population density
//////////////////////////////////////////////////
// Use mouse to rotate view.
//
/////////////////////////////////////////////////////

// PeasyCam integration for simple mouse interactions
import peasy.*;
PeasyCam cam;

// texture variables
PImage worldMapPNG;
PImage background;
int mapWidth = 1600;
int mapHeight = 800;

// data variables
String populationCSV[];
String populationData[][];
int earliest = -600;
int latest = 2012;
float[][] meteorPositions;

// sphere variables
PVector[][] points;
int radius = 200;
int detailLon = 360;
int detailLat = 180;

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
  worldMapPNG = loadImage("worldmap3.jpg");
  background = loadImage("background.png");

  loadCSV();

  loadStars();
  
  loadSpherePoints();
}

void draw() {
  setup3DCanvas();
  rotateCanvas(t, 0.1);
  
  drawStars();
  
  drawSphere();

  //addNoiseOverlay();

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
  populationCSV = loadStrings("populationDensity.csv");
  populationData = new String[populationCSV.length][360];

  for (int i=0; i<populationCSV.length; i++) {
    populationData[i] = populationCSV[i].split(",");
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
  points = new PVector[detailLat+1][detailLon+1];

  for (int i=0; i<detailLat+1; i++) {
    float lat = map(i, 0, detailLat, PI, 0);
    for (int j =0; j<detailLon+1; j++) {
      float lon = map(j, 0, detailLon, PI, -PI);
      String densityFac = "";
      if (i < detailLat && j < detailLon) {
        densityFac = populationData[i][j];
      } else if (i == detailLat && j < detailLon) {
        densityFac = populationData[i-1][j];
      } else if (j == detailLon && i < detailLat) {
        densityFac = populationData[i][j-1];
      } else if (j == detailLon && i == detailLat) {
        densityFac = populationData[i-1][j-1];
      }
      float densityFactor = float(densityFac);
      if (densityFactor == 99999) {
        densityFactor = 1;
      } else {
        densityFactor = (densityFactor/4000) + 1;
      }
      if (densityFactor > 2) {
        println(densityFactor);
      }
      
      float x = densityFactor * radius * cos(lon) * sin(lat);
      float y = densityFactor * radius * sin(lon) * sin(lat);
      float z = densityFactor * radius * cos(lat);

      points[i][j] = new PVector(x, y, z);
    }
  }
}

void drawSphere() {
  // put points together for 3D shape
  PShape sphere = createShape(GROUP);
  sphere.beginShape();

  for (int i=0; i<detailLat; i++) {
    // create each horizontal strip individually and put together as group
    PShape strip = createShape();
    strip.beginShape(TRIANGLE_STRIP);

    strip.texture(worldMapPNG);
    for (int j=0; j<detailLon+1; j++) {
      PVector v1 = points[i][j];
      PVector v2 = points[i+1][j];
      strip.vertex(v1.x, v1.y, v1.z, j*mapWidth/detailLon, i*mapHeight/detailLat);
      //strip.normal(v1.x, v1.y, v1.z);
      strip.vertex(v2.x, v2.y, v2.z, j*mapWidth/detailLon, (i+1)*mapHeight/detailLat);
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