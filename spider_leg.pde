public class Leg {
  
  
  /*  ________VARIABLES________  */
  // init variables
  private final float leg_width; // 15
  private final int leg_bend; // -1 bends right, 1 bends left
  private final float thigh_length; // 100
  private final float calf_length; // 100
  private final PVector foot_anchor_offset; // determines where abouts the foot want to be
  
  // leg control variables
  private PVector pivot_pos = new PVector(400,400); // body/pivot location
  private PVector desired_foot_pos = new PVector(0,0);
  
  
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
    // given spider_pos and desired_foot_pos find:
    // foot_pos , thigh_length , thigh_angle , joint_pos , calf_length , calf_angle
    float distance = dist(pivot_pos.x,pivot_pos.y,desired_foot_pos.x,desired_foot_pos.y);
    float max_length = thigh_length + calf_length;
    
    // Clamping foot distance
    if (distance > max_length) {
      PVector desired_temp = new PVector(desired_foot_pos.x,desired_foot_pos.y);
      desired_foot_pos.sub(pivot_pos);
      foot_pos.set(desired_foot_pos.normalize().mult(max_length).add(pivot_pos));
      desired_foot_pos.set(desired_temp);
      distance = max_length;
    } else {
      foot_pos.set(desired_foot_pos);
    }
    
    // Thigh stuff
    //cosine rule
    PVector foot_temp = new PVector (foot_pos.x,foot_pos.y);
    PVector foot_relative = foot_pos.sub(pivot_pos);
    float foot_true_bearing = foot_relative.heading();
    float thigh_numerator = pow(thigh_length,2) + pow(distance,2) - pow(calf_length,2);
    float thigh_denominator = 2 * thigh_length * distance;
    thigh_angle = leg_bend * acos(thigh_numerator/thigh_denominator) + foot_true_bearing - PI/2;
    foot_pos.set(foot_temp);
    
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
  
  
  
  // computes the target foot location based on the displaced anchor thats floating to the left or right of the body
  public void computeFootTarget(PVector body_position, float bodyRotation) { 
    PVector closest_border_point = new PVector(0,0);
    PVector relative_offset_pos = foot_anchor_offset.copy().rotate(bodyRotation); // relative to the body
    PVector border_calc = new PVector(0,0); // manipulated to calculate which border is closest
    border_calc = body_position.copy().add(relative_offset_pos); // uhhhhh...its accounting for the offset and rotation of body 
    
    // calculating which axis is closer e.g.; (300,600) -> (-100,200) -> (100,200); therefore y is closer, also confirmed by going 800 - 600 = 200, and 200 < 300
    border_calc.sub(400,400);
    border_calc.set(abs(border_calc.x),abs(border_calc.y));
    
    if (border_calc.y >= border_calc.x) { // spider is closer to either top or bottom
    
      if (pivot_pos.y >= 400) { // spider is closer to bottom
        closest_border_point.set(body_position.x + relative_offset_pos.x,800);
        
      } else { // spider is closer to top
        closest_border_point.set(body_position.x + relative_offset_pos.x,0);
      }
      
    } else { // spider is closer to either left or right
    
      if (pivot_pos.x >= 400) { // spider is closer to right
        closest_border_point.set(800,body_position.y + relative_offset_pos.y);
        
      } else { // spider is closer to left
        closest_border_point.set(0,body_position.y + relative_offset_pos.y);
      }
    }
    this.setFootPos(closest_border_point);
  }
  
  
  
  
}
