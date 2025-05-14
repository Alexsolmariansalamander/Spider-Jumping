PVector spider_pos = new PVector(400,400); // Spider body location
// this is where the foot wants to be. This and spider_pos are the only 2 publicly modifiable values, the rest are changed only in calculate()
PVector desired_foot_pos = new PVector(0,0);
Leg spider_leg = new Leg(15,1,100,100);
Leg second_leg = new Leg(15,-1,100,100);
Leg third_leg = new Leg(15,1,100,100);
Leg forth_leg = new Leg(15,-1,100,100);

void setup() {
  size(800,800);
  frameRate(60);
}


void draw() {
  background(255);
  updateSpider();
}

void mouseClicked() {
  desired_foot_pos.set(mouseX, mouseY);
  //norm
  spider_leg.setFootPos(desired_foot_pos);
  //oposite side
  PVector sec_foot_pos = new PVector(width - desired_foot_pos.x,desired_foot_pos.y);
  second_leg.setFootPos(sec_foot_pos);
  PVector thi_foot_pos = new PVector(desired_foot_pos.x + 50,desired_foot_pos.y);
  third_leg.setFootPos(thi_foot_pos);
  PVector for_foot_pos = new PVector(width - desired_foot_pos.x - 50,desired_foot_pos.y);
  forth_leg.setFootPos(for_foot_pos);
}

void updateSpider() {
  spider_leg.setPivot(spider_pos);
  spider_leg.update();
  second_leg.setPivot(spider_pos);
  second_leg.update();
  third_leg.setPivot(spider_pos);
  third_leg.update();
  forth_leg.setPivot(spider_pos);
  forth_leg.update();
  // ____Body____
  fill(0);
  ellipse(spider_pos.x,spider_pos.y,75,75); 
  
  PVector foot_pos = new PVector(spider_leg.getFootPos().x,spider_leg.getFootPos().y);
  // testing
  fill(255,0,0);
  ellipse(foot_pos.x,foot_pos.y,25,25);
  fill(0,255,0);
  ellipse(desired_foot_pos.x,desired_foot_pos.y,15,15);
}
