///////////////////////////////////////////
//////////////////////////////////////////
// Video Color Palette
//
// Creates a color palette of each frame of a selected video.
// Mouse position controls the amount of colors the palette
// consists of.
///////////////////////////////////////

import processing.video.*;
Movie FightClubScene;

int movieHeight = 528;
int movieWidth = 1290;

color[] palette = new color[movieHeight*movieWidth];

void setup() {
  frameRate(30);
  size(1280, 728);
  
  colorMode(HSB, 255, 255, 255);
  FightClubScene = new Movie(this, "fightclubscene.mp4");
  FightClubScene.loop();
}

void draw() {
  if (FightClubScene.available()) {
    FightClubScene.read();
  }
  image(FightClubScene, 0, 0);
  loadPixels();
  
  int tileCount =  int(mouseX/5);
  int[] sortingPalette = new int[tileCount];
  float rectWidth = width / float(tileCount);
  float rectHeight = 200;
  
  
  // analyze colors and save in palette
  float totalPixels = movieHeight * movieWidth;
  float difference = totalPixels/tileCount;
  
    
  for (int i=0; i<tileCount; i++) {
    float hueVal = hue(pixels[int(i*difference)]);
    float satVal = saturation(pixels[int(i*difference)]);
    float briVal = brightness(pixels[int(i*difference)]);
    
    palette[i] = color(hueVal, satVal, briVal);
    sortingPalette[i] = int(briVal)*1000000 + int(satVal)*1000 + int(hueVal);
    println(sortingPalette[i]);
  }
  
  // sort the sortingPalette
  sort(sortingPalette);
  
  // convert back to colors in palette
  for (int i=0; i<tileCount; i++) {
    int briVal = int(sortingPalette[i]/1000000);
    int satVal = int((sortingPalette[i] - briVal*1000000)/1000);
    int hueVal = int(sortingPalette[i] - briVal*1000000 - satVal*1000);
    
    palette[i] = color(hueVal, satVal, briVal);
  }
  
  
  
  // sort colors in palette
  // sort all colors by hue
  // save full color as one number; then use this number to sort and then convert back to color and save
  // int(hueNum) * 1000000 + int(satNum) * 1000 + int(briNum)
  // save this to a new array. sort it.
  // then convert it back and save it back into palette array in right order
  
  
  // draw the whole color palette at the bottom
  for (int i=0; i < tileCount; i++) {
    fill(palette[i]);
    noStroke();
    rect(i*width/tileCount, movieHeight, width/tileCount, height-movieHeight);
  }
}
  
  
  
  