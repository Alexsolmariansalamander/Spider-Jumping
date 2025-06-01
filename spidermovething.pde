
/*---------------------------------------------------------------
 *  Author : Alexander Vissarion (49052829)
 *  Inspired by: nothing
 *  Description:
 *    Drives the main game loop, creating the window and calling different methods of the spider
 *    responding to different inputs e.g.; Move to mouse, Jump
 *---------------------------------------------------------------*/


Spider spider;

void setup() {
  size(800,800);
  frameRate(60);
  spider = new Spider();
}

void draw() {
  background(255);
  // updates the whole spider, legs, body, and draws them
  spider.update();
}

void mouseClicked() {
  spider.moveTo(new PVector(mouseX,mouseY));
}

void keyPressed() {
  if (keyPressed && key == 'j') {
    spider.jump();
  }
}
