///////////////////////////////////////////
//////////////////////////////////////////
// Cube Disco
//
// This sketch displays an animated glowing cube of dots
///////////////////////////////////////


int cubeWidth = 20;
int cubeHeight = 20;
int cubeDepth = 20;
int pointDistance = 20;
float transX = cubeWidth*pointDistance/2;
float transY = cubeHeight*pointDistance/2;
float transZ = cubeDepth*pointDistance/2;

float t;
float colChangeFactor;
float pointAnimFactor;
float pointAnimConstant;
int[] pointStatusArray = new int[cubeWidth*cubeHeight*cubeDepth];



void setup() {
  background(0);
  size(1000, 1000, P3D);
  
  stroke(255);
  strokeWeight(2);
  colorMode(HSB, 100, 100, 100);
}



void draw() {
  // setup the canvas
  background (0);
  translate(500,500,0);
  rotateY(radians(30));
  rotateZ(radians(40));
  
  // animated rotation of canvas
  rotateX(radians(sin(t/2)*360));
  rotateZ(radians(sin(t)*360));
  
  
  // arrange points in a three dimensional cube
  for (int w=0; w<cubeWidth; w++) {
    for (int h=0; h<cubeHeight; h++) {
      for (int d=0; d<cubeDepth; d++) {
         float colorHue = colorValue(w, h, d, colChangeFactor);
        
        // draw the point
        if (w==0 && h==0 || h==0 && d==0 || d==0 && w==0 || w==0 && h==cubeHeight-1 || w==0 && d==cubeDepth-1 || h==0 && w==cubeWidth-1 || h==0 && d==cubeDepth-1 || d==0 && w==cubeWidth-1 || d==0 && h==cubeHeight-1 || w==cubeWidth-1 && h==cubeHeight-1 || w==cubeWidth-1 && d==cubeDepth-1 || h==cubeHeight-1 && w==cubeWidth-1 || h==cubeHeight-1 && d==cubeDepth-1 || d==cubeDepth-1 && w==cubeWidth-1 || d==cubeDepth-1 && h==cubeHeight-1) {
          // points on outline of cube are drawn white
          stroke(100,0,100);
          drawPoint(pointDistance, pointDistance, pointDistance, w, h, d, transX, transY, transZ);
        } else {
          // points inside the cube are drawn based on rainbow gradient
          stroke(colorHue, 100, 100);
          
          // blinking animation is created by saving the on-off-status of every dot in an array; this array is updated from time to time creating the blinking effect
          int arrayPosition = w + h*cubeWidth + d*cubeWidth*cubeHeight;
          // use time until a rounded number changes as a trigger to update displayed dots
          if (pointAnimConstant != int(pointAnimFactor) && int(pointAnimFactor) != 0) {
            // define a new range of displayed dots randomly
            if (random(0,1)<0.7) { 
              drawPoint(pointDistance, pointDistance, pointDistance, w, h, d, transX, transY, transZ);
              pointStatusArray[arrayPosition] = 1;
            } else {
              pointStatusArray[arrayPosition] = 0;
            }   
          } else {
            // display same dots as before going through stored array
            if (pointStatusArray[arrayPosition] == 1) {
              drawPoint(pointDistance, pointDistance, pointDistance, w, h, d, transX, transY, transZ); 
            }
          }
        }
      }
    }
  }
  
  // update for next iteration
  pointAnimConstant = int(pointAnimFactor);
  t += 0.0011;
  colChangeFactor += 0.15;
  pointAnimFactor += 0.2;
}

// FUNCTIONS
void drawPoint(float x, float y, float z, int w, int h, int d, float transX, float transY, float transZ) {
  // draw point based on w,h,d values and based on object
  point(w*x-transX, y*h-transY, z*d-transZ);
}

float colorValue(int w, int h, int d, float changeRate) {
   // calculate color for this dot; create a three-dimensional rainbow-gradient; each point has a different value on this gradient
  float pointVal = (w+1)*(h+1)*(d+1); 
  float mapStart = 0+(colChangeFactor%100);
  float mapEnd = 100+(colChangeFactor%100);
  float colorHue = map(pointVal, 0, cubeWidth*cubeHeight*cubeDepth, 0+mapStart, 100+mapEnd);
  if (colorHue > 100) {
    colorHue-=100;
  }
  return colorHue;
}