public class Spider {
   /*  ________VARIABLES________  */
   
  // body control variables
  private PVector position = new PVector(width/2,height * 9/10); // Spider body location
  private PVector target_position = new PVector(0,0); // where spider wants to be
  private PVector velocity = new PVector(0,0); // 
  private float move_speed = 4;
  private float rotation = PI/4; // spiders body rotation
  private boolean is_moving = false;
  private boolean is_jumping = false;
  private float gravity = 10; // px/s
  
  
  
  // Legs
  Leg leg1 = new Leg(15,1,100,100,new PVector(-150,0)); // outer left leg
  Leg leg2 = new Leg(15,1,90,90,new PVector(-100,0)); // inner left leg
  Leg leg3 = new Leg(15,-1,100,100,new PVector(150,0)); // outer right leg
  Leg leg4 = new Leg(15,-1,90,90,new PVector(100,0)); // inner right leg
  
  //Leg leg1 = new Leg(15,1,80,85,new PVector(-80,0)); // back left leg
  //Leg leg2 = new Leg(15,1,100,100,new PVector(-150,0)); // outer left leg
  //Leg leg3 = new Leg(15,1,90,90,new PVector(-110,0)); // inner left leg
  //Leg leg4 = new Leg(15,-1,80,85,new PVector(80,0)); // back right leg
  //Leg leg5 = new Leg(15,-1,100,100,new PVector(150,0)); // outer right leg
  //Leg leg6 = new Leg(15,-1,90,90,new PVector(110,0)); // inner right leg
  
  
  private final Leg[] legs = {leg1,leg2,leg3,leg4};
  
  
  /*  ________CONSTRUCTOR________  */ 
 
  public Spider() {
    this.leg1.setFootPos(new PVector(width/2,height));
  }
  
  
  
  /*  ________METHODS________  */ 
  
  public void update(){
    // moves body
    if (is_moving){
      moveTo(target_position);}
    if (is_jumping) {
      jump();
    }
    
    // moves and draws legs
    for (Leg leg : legs) {
      leg.setPivot(position);
      leg.computeFootTarget(rotation);
      leg.update();
    }
    this.averageRotation();
    // draws body
    this.render(); // has to draw over the legs
  }
  
  
  
  public void render(){
    // ____Body____
    fill(0);
    ellipse(position.x,position.y,75,75); 
    
    // testing
    fill(0,255,0);
    ellipse(target_position.x,target_position.y,15,15);
  }
  
  
  
  public void moveTo(PVector moving_to) {
    if (is_moving == false || moving_to != target_position) {
      is_moving = true;
      target_position.set(moving_to);
      PVector direction = target_position.copy().sub(position).normalize(); 
      velocity.set(direction.mult(move_speed));
    }
    else {
      position.add(velocity);
      if (position.dist(moving_to) <= move_speed) {
        is_moving = false;
        position.set(moving_to);
        velocity.set(new PVector(0,0));
      }
    }
  }
  
  
  
  private void averageRotation() {
    PVector running_total = new PVector(0,0);
    for (Leg leg : legs){
      float max_reach = leg.getLegLength();
      float d = leg.getFootPos().dist(this.position);
      float w = map(constrain(d, 0, max_reach), 0, max_reach, 1, 0.2);
      running_total.add(leg.getNormal().mult(w));
    }
    running_total.mult(-1);
    
    rotation = running_total.heading() + PI/2;
  }
  
  private void jump() {
    if (!is_jumping) {
      PVector mouse_rel = new PVector(mouseX,mouseY).sub(position).normalize();
      float jump_vel = 10;
      velocity.set(mouse_rel.mult(jump_vel));
      println("Jumping");
      is_jumping = true;
      
    } else {
      PVector gravity_vec = new PVector(0 , gravity/frameRate);
      velocity.add(gravity_vec);
      position.add(velocity);
      println("velocity: " + velocity);
      if (is_on_a_wall(50)) {
        println("final  velocity: " + velocity);
        is_jumping = false;
        velocity.set(new PVector(0,0));
      }
    }

  }
  
  private boolean is_on_a_wall(float minimum_to_wall) {
    //PVector anchor_pos = foot_anchor_offset.copy().rotate(bodyRotation).add(pivot_pos); // == position
    //float leg_length = thigh_length + calf_length; // some distance to wall
    float dist_trigger = minimum_to_wall;
    // getting each wall position relative to anchor_pos
    PVector left_wall_pos = new PVector(800,position.y);
    PVector right_wall_pos = new PVector(0,position.y);
    PVector top_wall_pos = new PVector(position.x,0);
    PVector bot_wall_pos = new PVector(position.x,800);
    PVector[] walls = {left_wall_pos, right_wall_pos, top_wall_pos, bot_wall_pos};

    for (PVector wall_pos : walls) {
      float dist_body = wall_pos.dist(position);
      // if the wall is within reach
      if (dist_body < dist_trigger) {
        return true;
        }
      }
    return false;
  }
  

}
