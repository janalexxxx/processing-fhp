///////////////////////////////////////////
//////////////////////////////////////////
// Rainbow Lines
//
// This sketch displays an animated pattern of racing lines
///////////////////////////////////////


float t;

static final int NUM_LINES = 200;

void setup() {
  background(240);
  size(500,500);
  colorMode(HSB,NUM_LINES,100,100);
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(2);
  
  translate(width/2,height/2);
  stroke(frameCount%255,100,100);
  
  for (int i=0; i<NUM_LINES; i++) {
    float addition = i*0.5;
    float hueVal = i;
    stroke(hueVal,50,100);
    line(x1(t+addition),y1(t+addition),x2(t+addition),y2(t+addition));
  }
  
  if (frameCount % 5 ==0) {
    line(x1(t),y1(t),x2(t),y2(t));
  }
  
  
  t+=0.5;
}


float x1(float t) {
  return sin(t/10)*100 + sin(t/20)*30;
}

float y1(float t) {
  return cos(t/10)*30;
}

float x2(float t) {
  return sin(t/10)*200 + sin(t/5)*2;
}

float y2(float t) {
  return cos(t/20)*200 + cos(t/12)*20;
}