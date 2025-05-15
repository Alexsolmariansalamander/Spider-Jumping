PVector spider_pos = new PVector(400,400); // Spider body location
PVector spider_vel = new PVector(0,0);
boolean is_moving = false;

// this is where the foot wants to be. This and spider_pos are the only 2 publicly modifiable values, the rest are changed only in calculate()
PVector desired_spider_pos = new PVector(0,0);
Leg spider_leg = new Leg(15,1,100,100);


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
  updateLegs();
  
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
  println(is_moving + " " + spider_pos + " " + moving_to + "" + (spider_pos.dist(moving_to) == 0) +" ");
}


void updateLegs(){
  PVector closest_border_point = new PVector(0,0);
  PVector closest_border = new PVector(0,0);
  closest_border_point = spider_pos.copy();
  closest_border = spider_pos.copy();
  
  // calculating which axis is closer e.g.; (300,600) -> (-100,200) -> (100,200); therefore y is closer, also confirmed by going 800 - 600 = 200, and 200 < 300
  closest_border.sub(400,400);
  closest_border.set(abs(closest_border.x),abs(closest_border.y));
  
  if (closest_border.y >= closest_border.x) { // spider is closer to either top or bottom
  
    if (spider_pos.y >= 400) { // spider is closer to bottom
      closest_border_point.set(spider_pos.x,800);
      
    } else { // spider is closer to top
      closest_border_point.set(spider_pos.x,0);
    }
    
  } else { // spider is closer to either left or right
  
    if (spider_pos.x >= 400) { // spider is closer to right
      closest_border_point.set(800,spider_pos.y);
      
    } else { // spider is closer to left
      closest_border_point.set(0,spider_pos.y);
    }
  }
  spider_leg.setFootPos(closest_border_point);
}
