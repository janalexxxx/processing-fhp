//////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
// Pitcher - a gesture based music controller using the Myo hardware
///////////////////////////////////////////////////////////////
// Using this sketch you can play, pause, speed up and slow down your music through 
// simple hand gestures. The sketch uses the features of the MYO wristband to make
// that possible. Once the sketch is running and the MYO wristband connected, the 
// music is controlled with the following gestures:
//
// SPREAD FINGERS -> Play music
// FIST -> Pause music
// WAVE IN -> Speed up music
// WAVE OUT -> Slow down music
// DOUBLE TAP -> Keep current pace
//
//
// Have fun!
//
/////////////////////////////////////////////////////////


//Import MYO
import de.voidplus.myo.*;
Myo myo;

// Import sound library (we use Beads)
import beads.*;
import java.util.Arrays; 

// Audio control variables
AudioContext ac;
SamplePlayer player;
Glide ourGlide;
float speedValue = 1;
boolean increaseSpeed = false;
boolean decreaseSpeed = false;

// Drawing variables
color fore = color(255, 102, 204);
color back = color(0,0,0);


void setup() {
  size(300,300);
  
  // Setup MYO
  myo = new Myo(this);
  
  // Setup audio playback
  ac = new AudioContext();
  String audioFileName = "/Users/Stefanie/Documents/Processing/InterfaceLabor/fhp11_girlPower/fhp11_girlPower02/data/LoveYourself.mp3";
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
  Gain g = new Gain(ac, 2, 0.2);
  g.addInput(player);
  ac.out.addInput(g);
  ourGlide =  new Glide(ac, speedValue);
  player.setPitch(ourGlide);
  ac.stop();
}



void draw() {
  // draw fancy graphic
  loadPixels();
  //set the background
  Arrays.fill(pixels, back);
  //scan across the pixels
  for(int i = 0; i < width; i++) {
    //for each pixel work out where in the current audio buffer we are
    int buffIndex = i * ac.getBufferSize() / width;
    //then work out the pixel height of the audio data at that point
    int vOffset = (int)((1 + ac.out.getValue(0, buffIndex)) * height / 2);
    //draw into Processing's convenient 1-D array of pixels
    vOffset = min(vOffset, height);
    pixels[vOffset * height + i] = fore;
  }
  updatePixels();
  
  // set speed of audio playback
  ourGlide.setValue(speedValue);
  
  // change speed if selected
  if (increaseSpeed) {
    speedValue += 0.0005;
  }
  if (decreaseSpeed) {
    speedValue -= 0.0005;
  }
}



// react to different gestures of the MYO device
void myoOnPose(Device myo, long timestamp, Pose pose) {
  println("Sketch: myoOnPose() has been called");
  switch (pose.getType()) {
    case REST:
      println("Pose: REST");
      break;
    case FIST:
      ac.stop();
      println("Pose: FIST");
      increaseSpeed = false;
      decreaseSpeed = false;
      
      break;
    case FINGERS_SPREAD:
      ac.start();
      println("Pose: FINGERS_SPREAD");
      increaseSpeed = false;
      decreaseSpeed = false;
      speedValue = 1;
      break;
    case DOUBLE_TAP:
      println("Pose: DOUBLE_TAP");
      increaseSpeed = false;
      decreaseSpeed = false;
      break;
    case WAVE_IN:
      println("Pose: WAVE_IN");
      increaseSpeed = true;
      decreaseSpeed = false;
      break;
    case WAVE_OUT:
      println("Pose: WAVE_OUT");
      increaseSpeed = false;
      decreaseSpeed = true;
      break;
    }
  }