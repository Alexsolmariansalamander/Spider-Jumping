public class Spider {
   /*  ________VARIABLES________  */
   
  // body control variables
  private PVector position = new PVector(width/2,height * 9/10); // Spider body location
  private PVector target_position = new PVector(0,0); // where spider wants to be
  private PVector velocity = new PVector(0,0); // 
  private float rotation = PI/4; // spiders body rotation
  private boolean is_moving = false;
  
  
  
  // Legs
  //Leg leg1 = new Leg(15,1,90,90,new PVector(-100,0)); // inner left leg
  //Leg leg2 = new Leg(15,1,100,100,new PVector(-150,0)); // outer left leg
  //Leg leg3 = new Leg(15,-1,90,90,new PVector(100,0)); // inner right leg
  //Leg leg4 = new Leg(15,-1,100,100,new PVector(150,0)); // outer right leg
  Leg leg1 = new Leg(15,1,100,100,new PVector(-150,0)); // outer left leg
  Leg leg2 = new Leg(15,1,90,90,new PVector(-100,0)); // inner left leg
  Leg leg3 = new Leg(15,-1,100,100,new PVector(150,0)); // outer right leg
  Leg leg4 = new Leg(15,-1,90,90,new PVector(100,0)); // inner right leg
  
  private final Leg[] legs = {leg1,leg2,leg3,leg4};
  
  
  /*  ________CONSTRUCTOR________  */ 
 
  public Spider() {
    this.leg1.setFootPos(new PVector(width/2,height));
  }
  
  
  
  /*  ________METHODS________  */ 
  
  public void update(){
    
    // moves body
    if (is_moving == true){
      moveTo(target_position);}
    
    // moves and draws legs
    this.averageRotation();
    for (int i = 0; i < legs.length; i++){
      legs[i].computeFootTarget(position, rotation);
      legs[i].setPivot(position);
      legs[i].update();
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
    if (is_moving == false) {
      is_moving = true;
      target_position.set(moving_to);
    }
    else {
      position.set(moving_to.x, moving_to.y);
      
      if (position.dist(moving_to) == 0) {
        is_moving = false;
      }
    }
  }
  
  private void averageRotation() {
    PVector running_total = new PVector(0,0);
    for (int i = 0; i < legs.length; i++){
      running_total.add(legs[i].getNormal()); 
    }
    running_total.mult(-1);
    
    rotation = running_total.heading() + PI/2;
    
  }
  
  
  

}
