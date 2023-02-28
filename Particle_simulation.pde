int draw_mode = 0;//DO NOT CHANGE VARIABLE START VALUE
//0 for draw protons, 1 for draw electrons, 2 for execute
ArrayList<Proton> protons;
ArrayList<Electron> electrons;
ArrayList<Photon> photons;
float constant = 500; // 1/4piE
int edge_repel_mode = 1;
//0=dont repel, 1=reflect on impact, 2=repulsive force within 20 pixels
boolean trail = true;

void setup(){
  fullScreen();
  background(0);
  //size(500,500);
  protons = new ArrayList<Proton>();
  electrons = new ArrayList<Electron>();
  photons = new ArrayList<Photon>();
}


void mousePressed(){
  if(draw_mode==0){
     Proton p = new Proton(mouseX,mouseY,0,0);
     protons.add(p);
  }else if(draw_mode==1){
     Electron e = new Electron(mouseX,mouseY,0,0);
     electrons.add(e);
  }else{
    Photon p = new Photon(mouseX,mouseY,random(-1,1),random(-1,1),2);
    photons.add(p);
  }
  
}

void keyPressed(){
  if (key==' '){
    draw_mode ++; 
  }
}

void draw(){
  if (trail){
    noStroke();
    fill(0,25);
    rect(0,0,width,height);
  }else{
    background(0);
  }
  if (draw_mode<2){//draw start state
    for(Proton p : protons){
      p.show();
    }
    for(Electron e : electrons){
      e.show();
    }

  }else{//execute
    for(Proton p : protons){
      p.update();
      p.show();
    }
    for(Electron e : electrons){
      e.update();
      e.show();
    }
    
    for(int i=0; i<photons.size();i++){
      photons.get(i).update();
      photons.get(i).show();
      
      if (photons.get(i).energy >=2){
        int chance = int(random(0,300));//on average will take 300 frames(5 seconds) to pair produce
        if(chance==0){
          photons.get(i).pairproduction();
          photons.remove(i);
          break;
        }
      }
    }
    
    for(int i=0; i<photons.size();i++){
      for(int j=0; j<photons.size();j++){
        if(i!=j){
          if (photoncollide(photons.get(i),photons.get(j))){
            
            float X = (photons.get(i).pos.x+photons.get(j).pos.x)/2;//average x
            float Y = (photons.get(i).pos.y+photons.get(j).pos.y)/2;//average y
            float vx = photons.get(i).vel.y;
            float vy = photons.get(j).vel.x;
            
            //photons collide and make photon of double energy, sufficient to pair produce
            Photon l = new Photon(X,Y,vx,vy,2);
            photons.add(l);
            
            photons.remove(i);
            photons.remove(j);

          }
        }
      }
    }
    
    for(int i=0;i<protons.size();i++){
      for(int j=0;j<electrons.size();j++){
        if(collide(protons.get(i),electrons.get(j))){
          
          float X = (protons.get(i).pos.x+electrons.get(j).pos.x)/2;//average x
          float Y = (protons.get(i).pos.y+electrons.get(j).pos.y)/2;//average y
          float vx = protons.get(i).vel.y;
          float vy = electrons.get(j).vel.x;
          //by using y velocity of components to calculate x velocity of photon
          //the swapping of x and y causes the photon to move at 90 degrees
          
          Photon l1 = new Photon(X,Y,vx,vy,1);
          Photon l2 = new Photon(X,Y,-vx,-vy,1);
          photons.add(l1);
          photons.add(l2);
          
          protons.remove(i);
          electrons.remove(j);
          
          break; //break inner loop
          //if a proton has hit an electron it cant hit any more, so stop checking
        }
      }
    }
  }
  
}

boolean collide(Proton p, Electron e){
  float X = p.pos.x - e.pos.x;
  float Y = p.pos.y - e.pos.y;
  float dist = sqrt(sq(X)+sq(Y));
  if(dist<=10){
    return true; 
  }
  return false;
}

boolean photoncollide(Photon p1, Photon p2){
  float X = p1.pos.x - p2.pos.x;
  float Y = p1.pos.y - p2.pos.y;
  float dist = sqrt(sq(X)+sq(Y));
  if(dist<=5){
    return true; 
  }
  return false;
}
