class Photon{
  PVector pos;
  PVector vel;
  int energy;
  
  //constructor
  Photon(float x, float y, float vx, float vy, int e){
    pos = new PVector(x,y);
    vel = new PVector(vx,vy);
    vel.setMag(10);
    energy = e;
  }
  
  void update(){ 
    //repel from edges
    if(pos.x<=10){
      pos.x=10;
      vel.x*=-1;
    }
    if(pos.x>=width-10){
      pos.x=width-10;
      vel.x*=-1;
    }
    if(pos.y<=10){
      pos.y=10;
      vel.y*=-1;
    }
    if(pos.y>=height-10){
      pos.y=height-10;
      vel.y*=-1;
    }
    
    pos.add(vel);
  }
  
  
  void show(){
    strokeWeight(5);
    if(energy>=2){
      stroke(255,200,0);
    }else{
      stroke(255,255,0); 
    }
    point(pos.x,pos.y); 
  }
  
  void pairproduction(){
    Proton p = new Proton(pos.x+10,pos.y+10,vel.y/2,vel.x/2);
    Electron e = new Electron(pos.x-10,pos.y-10,-vel.y/2,-vel.x/2);
    protons.add(p);
    electrons.add(e);
  }
  
}
