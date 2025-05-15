PVector spider_pos = new PVector(400,400); // Spider body location
PVector spider_vel = new PVector(0,0);
float spider_rot = 0; // spiders body rotation
boolean is_moving = false;

// this is where the foot wants to be. This and spider_pos are the only 2 publicly modifiable values, the rest are changed only in calculate()
PVector desired_spider_pos = new PVector(0,0);
Leg spider_leg = new Leg(15,1,100,100,new PVector(-100,0));


void setup() {
  size(800,800);
  frameRate(60);
  spider_leg.setFootPos(new PVector(width/2,height));
}


void draw() {
  background(255);
  
  // handles body movement
  if (is_moving == true){
    moveToPoint(desired_spider_pos);}
  // handles leg movement
  spider_leg.computeFootTarget(spider_pos, spider_rot);
  
  // handles drawing whole spider
  updateSpider();
}

void mouseClicked() {
  //norm
  moveToPoint(new PVector(mouseX,mouseY));
}



void updateSpider() {
  spider_leg.setPivot(spider_pos);
  spider_leg.update();

  // ____Body____
  fill(0);
  ellipse(spider_pos.x,spider_pos.y,75,75); 
  
  PVector foot_pos = new PVector(spider_leg.getFootPos().x,spider_leg.getFootPos().y);
  // testing
  fill(255,0,0);
  ellipse(foot_pos.x,foot_pos.y,25,25);
  fill(0,255,0);
  ellipse(desired_spider_pos.x,desired_spider_pos.y,15,15);
}


void moveToPoint(PVector moving_to) {
  if (is_moving == false) {
    is_moving = true;
    desired_spider_pos.set(moving_to);
  }
  else {
    spider_pos.set(moving_to.x, moving_to.y);
    
    if (spider_pos.dist(moving_to) == 0) {
      is_moving = false;
    }
  }
}
