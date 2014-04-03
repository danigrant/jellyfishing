import processing.video.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

ArrayList<Jellyfish> jellies;
Net net;
PImage background;

MotionDetector theDetector;

Minim minim;
AudioPlayer song;
AudioPlayer swoosh;

Volume volume;

void setup() {
  background = loadImage("background.jpg");
  size(background.width, background.height);
  background(255, 204, 0);

  theDetector = new MotionDetector(this, 640, 480, true);

  jellies = new ArrayList<Jellyfish>();
  Jellyfish jelly = new Jellyfish();
  jellies.add(jelly);

  net = new Net();

  minim = new Minim(this);
  song = minim.loadFile("song.mp3");
  swoosh = minim.loadFile("highswoosh.wav");
  swoosh.setGain(-15);
  //song.play();
  volume = new Volume();
}

void draw() { 
  image(background, 0, 0);
  if (volume.on) {
    song.play();
  }
  else {
    song.pause();
    song.cue(0);
  }

  theDetector.run();

  //move the jellies and remove if necessary
  for (int i = 0; i < jellies.size(); i++) {
    Jellyfish temp = jellies.get(i);
    temp.move();
    temp.display();
    if (temp.xPos < -1 - temp.image.getWidth() || temp.xPos > width + 1 + temp.image.getWidth()) {
      jellies.remove(i);
    }

    //check hit
    boolean test = theDetector.checkHit((int) temp.xPos, (int) temp.yPos, temp.image.getWidth(), temp.image.getWidth());
    if (test) {
      jellies.remove(i);
      if (volume.on) {
        swoosh.pause();
        swoosh.cue(0);
        swoosh.play();
      }
    }
  }

  net.update();
  net.direction();
  //net.display();

  //maybe create a new jelly
  if (jellies.size() < 4 && random(1) > 0.95)
  {
    Jellyfish temp = new Jellyfish();

    // add it to our list
    jellies.add(temp);
  }
  theDetector.drawVideo(width-160, 0, 160, 120);
  volume.display();
}

void mousePressed() {
  net.swing();
  volume.mute();
}

void stop() {
  minim.stop();
  super.stop();
}

