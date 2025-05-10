PVector spider_pos = new PVector(400,400); // Spider body location
// These make up the leg of the spider, all values are determined in calculate() *apart from leg_width
float leg_width = 15;
float thigh_length = 100;
float thigh_angle = 0;
PVector joint_pos = new PVector(400,400 + 200); // leg joing
float calf_length = 60;
float calf_angle = 0;
PVector foot_pos = new PVector(0,0);
// this is where the foot wants to be. This and spider_pos are the only 2 publicly modifiable values, the rest are changed only in calculate()
PVector desired_foot_pos = new PVector(0,0);
  
int x = 0;
int y = 0;


void setup(){
  size(800,800);
  frameRate(60);
}


void draw(){
  background(255);
  calculate();
  draw_spider();
  windowMove(x,y);
  x += 2;
  y += 1;

}

void mouseClicked(){
  desired_foot_pos.set(mouseX, mouseY);
}

void draw_spider(){  
  // ____Leg____
  
  fill(100);
  
  // thigh
  pushMatrix();
  translate(spider_pos.x, spider_pos.y);
  rect(-leg_width/2,0, leg_width,thigh_length);
  rotate(thigh_angle);
  popMatrix();
  
  // calf
  pushMatrix();
  translate(joint_pos.x, joint_pos.y);
  rect(-leg_width/2,0, leg_width, calf_length);
  rotate(calf_angle);
  popMatrix();
  
  // joint
  circle(joint_pos.x, joint_pos.y, 20);
  
  
  // ____Body____
  
  fill(0);
  ellipse(spider_pos.x,spider_pos.y,75,75);
  
}

// Calculates all the variable values of the spiders legs and body, so that it can then be drawn
void calculate(){
  // given spider_pos and desired_foot_pos find:
  // foot_pos , thigh_length , thigh_angle , joint_pos , calf_length , calf_angle
  PVector distance = PVector.sub(spider_pos,desired_foot_pos);
}
