class MotionDetector
{
  // live video
  Capture video;

  // keep track of the previous frame of video
  PImage previousFrame;

  // threshold to qualify a pixel as being different
  int threshold = 30;

  // % change necessary to qualify as a hit
  float percentChangeNeeded = 0.50;

  // debug  mode
  boolean debug = true;

  // mirror mode
  boolean mirror = true;

  // construct a new MotionDetector - this class takes care of grabbing video,
  // memorizing previous frames and computing hits at particular regions of the screen
  MotionDetector(PApplet canvas, int w, int h, boolean m)
  {
    // grab an array of our cameras
    String[] cameras = Capture.list();

    // create a new video object
    video = new Capture(canvas, w, h); 
    //    video = new Capture(canvas, cameras[15]);
    video.start(); 

    // also create a previous frame PImage
    previousFrame = new PImage(w, h);

    // do we want to mirror video?
    mirror = m;
  }

  // running mode
  // this method should be called in the draw() method to continually bring in new video frames
  // and refresh the previous frame
  void run()
  {
    if (video.available())
    {
      // take the current frame of video and copy it into our previous frame of video
      video.loadPixels();
      previousFrame.loadPixels();
      arraycopy(video.pixels, previousFrame.pixels);
      previousFrame.updatePixels();

      // now read a new frame of video
      video.read();

      // do we want to "mirror" the video? (i.e. flip it horizontally)?
      if (mirror)
      {
        mirrorImage(video);
      }
    }
  }


  // check hit
  // given an x and y position as well as a width and a height this method
  // will return to you whether a hit has occured within this space
  boolean checkHit(int xPos, int yPos, int w, int h)
  {
    // load up our pixel arrays
    video.loadPixels();
    previousFrame.loadPixels();

    // construct our iteration ranges, making sure to not go off screen
    int xPosStart = constrain(xPos, 0, video.width-1);
    int yPosStart = constrain(yPos, 0, video.height-1);
    int xPosEnd   = constrain(xPos+w, 0, video.width-1);
    int yPosEnd   = constrain(yPos+h, 0, video.height-1);

    // keep track of how many pixels we visited as well as how many have changed
    int numPixelsChanged = 0;
    int numPixelsVisited = 0;

    // keep track of the average location of motion on the screen
    int xMotionPosition = 0;
    int yMotionPosition = 0;

    // iterate over our range
    for (int x = xPosStart; x < xPosEnd; x++)
    {
      for (int y = yPosStart; y < yPosEnd; y++)
      {
        // determine our location
        int location = x + y*video.width;

        // keep track of this pixel
        numPixelsVisited++;

        // extract color values
        float currentRed   = red(video.pixels[location]);
        float currentGreen = green(video.pixels[location]);
        float currentBlue  = blue(video.pixels[location]);
        float previousRed   = red(previousFrame.pixels[location]);
        float previousGreen = green(previousFrame.pixels[location]);
        float previousBlue  = blue(previousFrame.pixels[location]);
        float difference = dist(currentRed, currentGreen, currentBlue, previousRed, previousGreen, previousBlue);

        // is this pixel very different than the one that was here in the previous frame?
        if (difference > threshold)
        {
          numPixelsChanged++;

          // add to our counter vars
          xMotionPosition += x;
          yMotionPosition += y;
        }
      }
    }

    //determine most active region
    if (numPixelsChanged > 0) {
      fill(255);
      noStroke();
      //ellipse(xMotionPosition/numPixelsChanged, yMotionPosition/numPixelsChanged, 25, 25);
    }

    // determine if this is a hit
    if (numPixelsVisited > 0)
    {
      // compute % change
      float percentChange = (float)numPixelsChanged / (float)numPixelsVisited;

      // is this enough to qualify as a hit?
      if (percentChange > percentChangeNeeded)
      {
        return true;
      }
      else
      {
        return false;
      }
    }

    // otherwise this was an invalid range - no hit!
    else
    {
      return false;
    }
  }

  void mirrorImage(PImage imageToMirror)
  {
    imageToMirror.loadPixels();
    for (int x = 0; x < imageToMirror.width/2; x++)
    {
      // compute opposite x position
      int oppositeX = imageToMirror.width-x-1;

      for (int y = 0; y < imageToMirror.height; y++)
      {
        // determine our location
        int location1 = x         + y*imageToMirror.width;
        int location2 = oppositeX + y*imageToMirror.width;

        // swap!
        color temp = imageToMirror.pixels[location1];
        imageToMirror.pixels[location1] = imageToMirror.pixels[location2];
        imageToMirror.pixels[location2] = temp;
      }
    }
    imageToMirror.updatePixels();
  }

  void drawVideo(int x, int y, int w, int h)
  {
    imageMode(CORNER);
    image(video, x, y, w, h);
  }
}

