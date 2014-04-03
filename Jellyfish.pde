class Jellyfish {
  float xPos;
  float yPos;
  int xSpeed;
  Animation image;

  Jellyfish() {
    int chance = (int) random(2);
    if (chance == 0) {
      image = new Animation("rJellyfish", 12);
      xPos = 0 - image.getWidth();
      xSpeed = (int) random(3, 6);
    } 
    else {
      image = new Animation("lJellyfish", 12);
      xPos = width + image.getWidth();
      xSpeed = (int) random(3, 6) * -1;
    }
    yPos = random(height/3);
  }

  void display() {
    image.display(xPos, yPos);
  }

  void move() {
    xPos += xSpeed;
  }
  
}

