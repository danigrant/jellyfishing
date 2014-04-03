class Net {
  float xPos;
  float yPos;
  int angle;
  PImage rImage;
  PImage lImage;
  PImage currentImage;

  Net() {
    rImage = loadImage("rNet.png");
    lImage = loadImage("lNet.png");
    currentImage = rImage;  
    angle = 0;
  }

  void display() {
    //if moving to left display accuate direction of net
    //and vice versa
    image(currentImage, xPos, yPos);
  }

  void update() {
    xPos = mouseX;
    yPos = mouseY;
  }

  void direction() {
    if ( pmouseX > mouseX) {
      currentImage = lImage;
    }
    else if (pmouseX < mouseX) {
      currentImage = rImage;
    }
  }

  void swing() {
    while (angle < 160) {
      pushMatrix();
      rotate(radians(angle));
      angle += 10;
      popMatrix();
    }
  }
}

