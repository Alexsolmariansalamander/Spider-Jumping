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
