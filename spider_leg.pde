
/*---------------------------------------------------------------
 *  Author : Alexander Vissarion (49052829)
 *  Inspired by: my big brain
 *  Description:
 *    Controls and draws the leg of the spider,
 *    uses inverse kinematics for drawing the legs,
 *    has an auto foot target method that finds the closest viable wall,
 *    and a step method that moves the leg towards the desired target pos
 *---------------------------------------------------------------*/


public class Leg {
  
  /*  ________VARIABLES________  */
  // init variables
  private final float leg_width; // 15
  private final int leg_bend; // -1 bends right, 1 bends left
  private final float thigh_length; // 100
  private final float calf_length; // 100
  private final PVector foot_anchor_offset; // determines where abouts the foot want to be
  private final float foot_speed = 8;
  
  // leg control variables
  private PVector pivot_pos = new PVector(400,400); // body/pivot location
  private PVector desired_foot_pos = new PVector(0,0);
  private PVector normal = new PVector(0,0);
  private boolean stepping = false; // foot is moving to desired foot_pos and is near a surface
  private boolean floating = false; // foot is not near surface, so just goes moves as close to desired foot_pos as possible
  
  
  // leg draw variables
  private float thigh_angle = 0;
  private PVector joint_pos = new PVector(400,400 + 200); // leg joing
  private float calf_angle = 0;
  private PVector foot_pos = new PVector(0,0);
  
  
  
  /*  ________CONSTRUCTOR________  */ 
 
  public Leg(float leg_width, int leg_bend, float thigh_length, float calf_length, PVector foot_anchor_offset) {
    this.leg_width = leg_width;
    this.leg_bend = Math.max(-1, Math.min(1, leg_bend));
    this.thigh_length = thigh_length;
    this.calf_length = calf_length;
    this.foot_anchor_offset = foot_anchor_offset;
  }
  
  
  
  /*  ________METHODS________  */ 
  
  
  // calculates and draws. The general call for updating the leg
  public void update() {
    step();
    solveIK();
    render();
  }
  
  
  
  // draws the leg in order of thigh -> calf -> knee/joint
  public void render() {
    fill(100);
    
    // thigh
    pushMatrix();
    translate(pivot_pos.x, pivot_pos.y);
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
  }
  
  
  
  // calculates the angles and positions of the leg segments using trig
  private void solveIK() {
    // given spider_pos and foot_pos find:
    // thigh_length , thigh_angle , joint_pos , calf_length , calf_angle
    float distance = dist(pivot_pos.x,pivot_pos.y,foot_pos.x,foot_pos.y);
    
    // Thigh stuff
    //cosine rule
    PVector foot_relative = foot_pos.copy().sub(pivot_pos);
    float foot_true_bearing = foot_relative.heading();
    float thigh_numerator = pow(thigh_length,2) + pow(distance,2) - pow(calf_length,2);
    float thigh_denominator = 2 * thigh_length * distance;
    thigh_angle = leg_bend * acos(thigh_numerator/thigh_denominator) + foot_true_bearing - PI/2;
    
    // Joint stuff
    //spider_pos + PVector(sin(angle) * thigh_length, cos(angle) * thigh_length)
    PVector joint_relative = new PVector(sin(thigh_angle - PI), cos(thigh_angle)).mult(thigh_length);
    joint_pos.set(joint_relative.add(pivot_pos));
    
    // Calf stuff
    //cosine rule, but adding slightly different rotation at the end (due to different reference location)
    float calf_numerator = pow(thigh_length,2) + pow(calf_length,2) - pow(distance,2);
    float calf_denominator = 2 * thigh_length * calf_length;
    calf_angle = leg_bend * acos(calf_numerator/calf_denominator) + thigh_angle + PI;
  }
  
  
  
  // get and set methods
  public void setPivot(PVector pos) {
    this.pivot_pos.set(pos);
  }
  public void setFootPos(PVector pos) {
    this.desired_foot_pos.set(pos);
  }
  public PVector getFootPos() {
    return foot_pos;
  }
  public PVector getNormal() {
    return normal;
  }
  public float getLegLength() {
    return thigh_length + calf_length;
  }
  public void set_floating(boolean floating) {
    this.floating = floating;
  }
  
  
  // computes the target foot location based on the displaced anchor thats floating to the left or right of the body
  public void computeFootTarget(float bodyRotation) { 
    PVector anchor_pos = foot_anchor_offset.copy().rotate(bodyRotation).add(pivot_pos); // relative to the body
    float leg_length = thigh_length + calf_length;
    // getting each wall position relative to anchor_pos
    PVector left_wall_pos = new PVector(800,anchor_pos.y);
    PVector right_wall_pos = new PVector(0,anchor_pos.y);
    PVector top_wall_pos = new PVector(anchor_pos.x,0);
    PVector bot_wall_pos = new PVector(anchor_pos.x,800);
    PVector[] walls = {left_wall_pos, right_wall_pos, top_wall_pos, bot_wall_pos};
    
    PVector closest_wall = new PVector();
    float closest_dist = 999; // closest distance
     
    for (PVector wall_pos : walls) {
      float dist_pivot = wall_pos.dist(pivot_pos);
      float dist_anchor = wall_pos.dist(anchor_pos);
      // if the wall is within reach
      if (dist_pivot < leg_length) {
        // check if its the current closest wall
        if (dist_anchor < closest_dist) {
          closest_dist = dist_anchor;
          closest_wall.set(wall_pos);
        }
      } 
    }
    
    // checking to see if any wall was in reach
    if (closest_dist == 999) { // no
      set_floating(true);
    } else { // yes
      this.setFootPos(closest_wall);
      set_floating(false);
    }
    
    // setting the normal
    // sadly switch statement doesnt work with PVector
    if (closest_wall.dist(left_wall_pos) == 0) {normal.set(1,0);}
    else if (closest_wall.dist(right_wall_pos) == 0) {normal.set(-1,0);}
    else if (closest_wall.dist(top_wall_pos) == 0) {normal.set(0,-1);}
    else if (closest_wall.dist(bot_wall_pos) == 0) {normal.set(0,1);}
    
    // testing, draws anchor positions as a blue dot
    fill(0,0,255);
    circle(anchor_pos.x,anchor_pos.y,10);
  } 
  
  
  
  // updates the foot_pos based on body_pos and desired_foot_pos
  
  private void step() {
    float piv_des_distance = dist(pivot_pos.x,pivot_pos.y,desired_foot_pos.x,desired_foot_pos.y);
    float foot_piv_distance = dist(foot_pos.x,foot_pos.y,pivot_pos.x,pivot_pos.y);
    float foot_des_distance = dist(foot_pos.x,foot_pos.y,desired_foot_pos.x,desired_foot_pos.y);
    float max_length = thigh_length + calf_length;
    
    
    
    // locks foot_pos to be within range
    if (foot_piv_distance > max_length) {
      foot_pos.sub(pivot_pos).normalize().mult(max_length+1).add(pivot_pos);
    }
    
    
    // checks if desired_foot_pos is within foot reach
      // No: floating = true ???     I think technically true
    
    if (floating) {
      PVector temp_des_foot_pos = desired_foot_pos;
      if (piv_des_distance <= max_length) {}
      else {
        desired_foot_pos.sub(pivot_pos).normalize().mult(max_length -0.1).add(pivot_pos);
      }
      foot_des_distance = dist(foot_pos.x,foot_pos.y,desired_foot_pos.x,desired_foot_pos.y);
      if (foot_des_distance <= foot_speed * 2){
        foot_pos.set(desired_foot_pos);
      } else {
        PVector vel_dir = foot_pos.copy().sub(desired_foot_pos).normalize();
        foot_pos.add(vel_dir.mult(-foot_speed));
      }
      desired_foot_pos.set(temp_des_foot_pos);
      // moves clamps desired_foot_pos.clone() to reachable range
      // moves foot towards desired_foot_pos in straight line ... Account for (foot_pos == desired_foot_pos)
    }
    
    else if (!stepping && !floating){
      // dont move foot
      if (foot_des_distance > 50 || foot_piv_distance >= max_length-1){
        stepping = true;
      }
    }
    
    else if (stepping) {
      // temp
      
      PVector vel_dir = foot_pos.copy().sub(desired_foot_pos).normalize();
      foot_pos.add(vel_dir.mult(-foot_speed));
      foot_des_distance = dist(foot_pos.x,foot_pos.y,desired_foot_pos.x,desired_foot_pos.y);
      if (foot_des_distance <= foot_speed * 2){
        stepping = false;
        foot_pos.set(desired_foot_pos);
      }
    }
    
    
    
    // testing
    fill(255,0,0); // red
    circle(foot_pos.x,foot_pos.y, 40);
    fill(255,255,0); // yellow
    circle(desired_foot_pos.x,desired_foot_pos.y, 20);
  }
  
  
  
}
