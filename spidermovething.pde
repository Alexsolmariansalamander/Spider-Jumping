vector spider_pos = new vector(10,10); // Spider body location
boolean move = false;
vector joint_pos = new vector(-7.5,100); // leg joing
float leg_width = 15;
float thigh_length = 100;
float calf_length = 60;
vector end_pos = new vector(0,0);
  


void setup(){
  size(900,900);
  frameRate(60);
}


void draw(){
  background(255);
  draw_spider();

}


void mouseMoved(){
  if (move) {
    spider_pos = new vector(mouseX,mouseY);
  }

}


void mouseClicked(){
  move = !move;
}

void draw_spider(){
  pushMatrix();
  translate(spider_pos.x, spider_pos.y);
  
  // spider body
  fill(0);
  ellipse(0,0,100,100);
  
  // thigh
  fill(100);

  rect(-leg_width/2,0, leg_width,thigh_length);
  // joint
  circle(0, 140, 20);
  
  // calf
  rect(joint_pos.x,joint_pos.y, leg_width, calf_length);
  
  popMatrix();
}

void calculate(){
  
}
