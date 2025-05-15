public class Spider {
   /*  ________VARIABLES________  */
   
  // body control variables
  private PVector position = new PVector(400,800); // Spider body location
  private PVector target_position = new PVector(0,0); // where spider wants to be
  private PVector velocity = new PVector(0,0); // 
  private float rotation = 0; // spiders body rotation
  private boolean is_moving = false;
  
  
  
  // Legs
  Leg leg = new Leg(15,1,100,100,new PVector(-100,0));
  
  
  
  
  /*  ________CONSTRUCTOR________  */ 
 
  public Spider() {
    this.leg.setFootPos(new PVector(width/2,height));
    this.position.set(new PVector(width/2,height));
    println((width/2) + " " + height +" " + " " );
  }
  
  
  
  /*  ________METHODS________  */ 
  
  public void update(){
    
    // moves body
    if (is_moving == true){
      moveTo(target_position);}
    
    // moves and draws legs
    leg.computeFootTarget(position, rotation);
    leg.setPivot(position);
    leg.update();
    
    // draws body
    this.render(); // has to draw over the legs
  }
  
  public void render(){
    // ____Body____
    fill(0);
    ellipse(position.x,position.y,75,75); 
    
    // testing
    PVector foot_pos = new PVector(this.leg.getFootPos().x,this.leg.getFootPos().y);
    fill(255,0,0);
    ellipse(foot_pos.x,foot_pos.y,25,25);
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
  
  
  

}
