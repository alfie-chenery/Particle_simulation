class Electron{
  PVector pos;
  PVector vel;
  PVector acc;
  
  //constructor
  Electron(float x, float y, float vx, float vy){
    pos = new PVector(x,y);
    vel = new PVector(vx,vy);
    acc = new PVector(0,0);
  }
  
    void update(){
    for(Proton p : protons){
      PVector force = new PVector(p.pos.x-pos.x,p.pos.y-pos.y);
      float distance = force.mag();
      force.setMag(constant/sq(distance));
      acc.add(force);         
    }
    for(Electron e : electrons){
      if(this != e){ //dont repel from itself
        PVector force = new PVector(e.pos.x-pos.x,e.pos.y-pos.y);
        float distance = force.mag();
        force.setMag(-constant/sq(distance));
        acc.add(force);
      }
      
    }
    
    if (acc.mag()>0.1){
      acc.setMag(0.1); 
    }
    
    if(edge_repel_mode==1){
      //repel from edges
      if(pos.x<=0){
        pos.x=0;
        acc.x*=-0.9;
        vel.x*=-0.9;
      }
      if(pos.x>=width){
        pos.x=width;
        acc.x*=-0.9;
        vel.x*=-0.9;
      }
      if(pos.y<=0){
        pos.y=0;
        acc.y*=-0.9;
        vel.y*=-0.9;
      }
      if(pos.y>=height){
        pos.y=height;
        acc.y*=-0.9;
        vel.y*=-0.9;
      }
    }else if(edge_repel_mode==2){
      for(int i=0;i<width;i++){
        PVector edge = new PVector(i-pos.x,0-pos.y);
        float dist = edge.mag();
        if(dist < 100){
          float speed = map(dist,0,100,0.05,0);
          edge.setMag(-speed);
          acc.add(edge);
        }        
      }
      for(int i=0;i<width;i++){
        PVector edge = new PVector(i-pos.x,height-pos.y);
        float dist = edge.mag();
        if(dist < 100){
          float speed = map(dist,0,100,0.05,0);
          edge.setMag(-speed);
          acc.add(edge);
        }        
      }
      for(int j=0;j<height;j++){
        PVector edge = new PVector(0-pos.x,j-pos.y);
        float dist = edge.mag();
        if(dist < 100){
          float speed = map(dist,0,100,0.05,0);
          edge.setMag(-speed);
          acc.add(edge);
        }        
      }
      for(int j=0;j<height;j++){
        PVector edge = new PVector(width-pos.x,j-pos.y);
        float dist = edge.mag();
        if(dist < 100){
          float speed = map(dist,0,100,0.05,0);
          edge.setMag(-speed);
          acc.add(edge);
        }        
      }
    }
    
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }
  
  void show(){
    strokeWeight(10);
    stroke(0,0,255);
    point(pos.x,pos.y); 
  }
}
