//library for rendering video
import processing.video.*;

//minim is a sound library for Processing
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

//holds all the jellyfish objects
ArrayList<Jellyfish> jellies;
PImage background;

MotionDetector theDetector;

Minim minim;
AudioPlayer song;
AudioPlayer swoosh;
//Volume refers to the image of sound on/off in the corner
Volume volume;

void setup() {
  background = loadImage("background.jpg");
  size(background.width, background.height);

  //init motion detection system
  theDetector = new MotionDetector(this, 640, 480, true);

  //init array of jellyfish and add the first jelly
  jellies = new ArrayList<Jellyfish>();
  Jellyfish jelly = new Jellyfish();
  jellies.add(jelly);

  //init sound system
  minim = new Minim(this);
  song = minim.loadFile("song.mp3");
  swoosh = minim.loadFile("swoosh.wav");
  swoosh.setGain(-15);
  volume = new Volume();
}

void draw() { 
  image(background, 0, 0);
  playMusic(volume);

  //run the movement detector, i.e. check for movement
  theDetector.run();

  //make the jellies swim and check if they've been hit
  jellySwimming();

  //maybe create a new jelly if not enough jellies on the screen
  drawJellies();

  //draw the video output in the upper right corner
  theDetector.drawVideo(width-160, 0, 160, 120);
  
  //draw the volume button in the upper left corner
  volume.display();
}

void playMusic(Volume v) {
  if (volume.on) {
    song.play();
  }
  else {
    song.pause();
    song.cue(0);
  }
}

void jellySwimming() {
  for (int i = 0; i < jellies.size(); i++) {
    //grab a temporary jellyfish
    Jellyfish temp = jellies.get(i);
    //move it to new location and display it at new location
    temp.move();
    temp.display();

    //if jelly has left the screen, remove it
    if (temp.xPos < -1 - temp.image.getWidth() || temp.xPos > width + 1 + temp.image.getWidth()) {
      jellies.remove(i);
    }

    //check if the temp jelly was hit
    boolean test = theDetector.checkHit((int) temp.xPos, (int) temp.yPos, temp.image.getWidth(), temp.image.getWidth());
    if (test) {
      jellies.remove(i);
      //make the jellyfish caught swoosh sound
      if (volume.on) {
        swoosh.pause();
        swoosh.cue(0);
        swoosh.play();
      }
    }
  }
}

void drawJellies() {
  //only draw a jellyfish if there are less than 4 jellies on the screen and if random chance says yes do it
  if (jellies.size() < 4 && random(1) > 0.95)
  {
    Jellyfish temp = new Jellyfish();

    // add it to our list of jellies
    jellies.add(temp);
  }
}

void mousePressed() {
  //the mute function checks if the mouse is over the volume button
  volume.mute();
}

void stop() {
  minim.stop();
  super.stop();
}

