PVector spider_pos = new PVector(400,400); // Spider body location
// These make up the leg of the spider, all values are determined in calculate() *apart from leg_width
float leg_width = 15;
int leg_bend = 1; // -1 bends right, 1 bends left
float thigh_length = 100;
float thigh_angle = 0;
PVector joint_pos = new PVector(400,400 + 200); // leg joing
float calf_length = 100;
float calf_angle = 0;
PVector foot_pos = new PVector(0,0);
// this is where the foot wants to be. This and spider_pos are the only 2 publicly modifiable values, the rest are changed only in calculate()
PVector desired_foot_pos = new PVector(0,0);



void setup() {
  size(800,800);
  frameRate(60);
}


void draw() {
  background(255);
  calculate();
  draw_spider();
}

void mouseClicked() {
  desired_foot_pos.set(mouseX, mouseY);
}

void draw_spider() {  
  // ____Leg____
  
  fill(100);
  
  // thigh
  pushMatrix();
  translate(spider_pos.x, spider_pos.y);
  rotate(thigh_angle);
  rect(-leg_width/2,0, leg_width,thigh_length);
  popMatrix();
  
  // calf
  pushMatrix();
  translate(joint_pos.x, joint_pos.y);
  rotate(calf_angle);
  rect(-leg_width/2,0, leg_width, calf_length);
  popMatrix();
  
  // joint
  circle(joint_pos.x, joint_pos.y, 20);
  
  
  // ____Body____
  
  fill(0);
  ellipse(spider_pos.x,spider_pos.y,75,75);
  
  
  // testing
  fill(255,0,0);
  ellipse(foot_pos.x,foot_pos.y,25,25);
  fill(0,255,0);
  ellipse(desired_foot_pos.x,desired_foot_pos.y,15,15);
}

// Calculates all the variable values of the spiders legs and body, so that it can then be drawn
void calculate() {
  // given spider_pos and desired_foot_pos find:
  // foot_pos , thigh_length , thigh_angle , joint_pos , calf_length , calf_angle
  float distance = dist(spider_pos.x,spider_pos.y,desired_foot_pos.x,desired_foot_pos.y);
  float max_length = thigh_length + calf_length;
  
  // Clamping foot distance
  if (distance > max_length) {
    PVector desired_temp = new PVector(desired_foot_pos.x,desired_foot_pos.y);
    desired_foot_pos.sub(spider_pos);
    foot_pos.set(desired_foot_pos.normalize().mult(max_length).add(spider_pos));
    desired_foot_pos.set(desired_temp);
    distance = max_length;
  } else {
    foot_pos.set(desired_foot_pos);
  }
  // Thigh stuff
  //cosine rule
  PVector foot_temp = new PVector (foot_pos.x,foot_pos.y);
  PVector foot_relative = foot_pos.sub(spider_pos);
  float foot_true_bearing = foot_relative.heading();
  float thigh_numerator = pow(thigh_length,2) + pow(distance,2) - pow(calf_length,2);
  float thigh_denominator = 2 * thigh_length * distance;
  thigh_angle = leg_bend * acos(thigh_numerator/thigh_denominator) + foot_true_bearing - PI/2;
  foot_pos.set(foot_temp);
  
  // Joint stuff
  //spider_pos + PVector(sin(angle) * thigh_length, cos(angle) * thigh_length)
  PVector joint_relative = new PVector(sin(thigh_angle - PI), cos(thigh_angle)).mult(thigh_length);
  joint_pos.set(joint_relative.add(spider_pos));
  
  // Calf stuff
  //cosine rule, but adding slightly different rotation at the end (due to different reference location)

  float calf_numerator = pow(thigh_length,2) + pow(calf_length,2) - pow(distance,2);
  float calf_denominator = 2 * thigh_length * calf_length;
  calf_angle = leg_bend * acos(calf_numerator/calf_denominator) + thigh_angle + PI;
  
}
