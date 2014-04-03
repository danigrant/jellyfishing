class Volume {
  boolean on;
  PImage onImage;
  PImage offImage;
  PImage currentImage;
  
  Volume(){
    on = true;
    onImage = loadImage("sound.png");
    offImage = loadImage("soundoff.png");
    currentImage = onImage;
  }
  
  public void display(){
    image(currentImage, 10, 10);
  }
  
  public void mute() {
    if (mouseX < 70 && mouseY < 70) {
      if (on) {
        on = false;
        currentImage = offImage;
      }
      else {
        on = true;
        currentImage = onImage;
      }
    }
  }
}
