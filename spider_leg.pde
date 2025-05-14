public class Leg {
  // init variables
  private final float leg_width; // 15
  private final int leg_bend; // -1 bends right, 1 bends left
  private final float thigh_length; // 100
  private final float calf_length; // 100
  
  // leg control variables
  private PVector pivot_pos = new PVector(400,400); // body/pivot location
  private PVector desired_foot_pos = new PVector(0,0);
  
  // leg draw variables
  private float thigh_angle = 0;
  private PVector joint_pos = new PVector(400,400 + 200); // leg joing
  private float calf_angle = 0;
  private PVector foot_pos = new PVector(0,0);
  
  public Leg(float leg_width, int leg_bend, float thigh_length, float calf_length) {
    this.leg_width = leg_width;
    this.leg_bend = Math.max(1, Math.min(-1, leg_bend));
    this.thigh_length = thigh_length;
    this.calf_length = calf_length;
  }
  
  // calculates and draws
  public void update() {
    calculate();
    drawLeg();
  }
  
  // draws in order of thigh -> calf -> knee/joint
  public void drawLeg() {
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
  }
  
  private void calculate() {
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
  
  public void setPivot(PVector pos) {
    this.pivot_pos.set(pos);
  }
  public void setFootPos(PVector pos) {
    this.desired_foot_pos.set(pos);
  }
  
  
}
