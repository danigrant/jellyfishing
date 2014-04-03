jellyfishing
============

Create a virtual reality jellyfishing game with Processing. See the game in action here: http://instagram.com/p/g_cA6BtvXP/

####How to change the background
Put whatever background image you'd like to use in the data folder and call it background.jpg. The screen size of the game will adjust to the size of that image.

####How to change the sound icon
Insert your own sound on/off icons by dropping the images into the data folder and calling the sound on icon sound.png and the sound off icon soundoff.png.

####How to use your own music
Call the main soundtrack song.mp3 and call the noise that happens when the jellyfish are caught swoosh.wav. Put both of these files in the data folder.

####How to use your own jellyfish
To use your own animated files instead of the jellyfish, add them to the data folder with the same prefix and then their order number i.e. jelly000.gif, jelly001.gif, jelly002.gif. 

I used 4 digit numbers (0000, 0001, 0002) to label my jellyfish animation images. If you use something else, you need to tell the Animation class how many digits you used. Change 4 in this statment:
	String filename = imagePrefix + nf(i, 4) + ".gif";
to however many digits you used. This is also where you would change the filetype if you did not use gifs.



