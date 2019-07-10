class Atom{
  Atom bond;
  color rang;
  int id, spin = -1, bondIdx;
  boolean still = false;
  PVector pos,vel,acc;
  
  float G = 0.5;
  int bondSize = 40;
  
  boolean[] hasBond = new boolean[3];
  PVector[] attractorsLeft = new PVector[3];
  PVector[] attractorsRight = new PVector[3];
  
  Atom(int id, PVector pos, color rang){
    this.id = id;
    this.pos = pos;
    this.rang = rang;
    
    vel = new PVector();
    acc = new PVector();
    
    for(int i = 0; i < 3; i++){
      hasBond[i] = false;  
    }
  }
  
  void updateAttractors(){
    attractorsLeft[0] = new PVector(pos.x + bondSize, pos.y);
    attractorsLeft[1] = new PVector(pos.x - bondSize * sin(PI/6), pos.y + bondSize * cos(PI/6));
    attractorsLeft[2] = new PVector(pos.x - bondSize * sin(PI/6), pos.y + bondSize * cos(5*PI/6));
    attractorsRight[0] = new PVector(pos.x - bondSize, pos.y);
    attractorsRight[1] = new PVector(pos.x + bondSize * sin(PI/6), pos.y - bondSize * cos(PI/6));
    attractorsRight[2] = new PVector(pos.x + bondSize * sin(PI/6), pos.y - bondSize * cos(5*PI/6));
  }
  
  void update(){
    this.checkLimits();
    if(bond==null){
      vel.add(acc);
      vel.limit(1);
      pos.add(vel);
      acc.mult(0);
    }else{
      
    }
    this.updateAttractors();
  }
  
  void interact(Atom atom){
    for(int i=0;i<3;i++){
      
    }
    PVector force = PVector.sub(atom.pos, this.pos);
    float d = force.mag();
    d = constrain(d,1,25);
    float attraction = G/(d*d);
    force.setMag(attraction);
    acc.add(force);
  }
  
  void checkLimits(){
    if(pos.x > width){
      pos.x = 0;
    }
    if(pos.y > height){
      pos.y = 0;
    }
    if(pos.x < 0){
      pos.x = width - 1;
    }
    if(pos.y < 0){
      pos.y = height - 1;
    }
  }
  
  void show(){
    fill(rang);
    ellipse(pos.x, pos.y, 8, 8);
    if(spin != -1){
      if(spin == 0){
        line(pos.x, pos.y, attractorsRight[0].x, attractorsRight[0].y);
        line(pos.x, pos.y, attractorsRight[1].x, attractorsRight[1].y);
        line(pos.x, pos.y, attractorsRight[2].x, attractorsRight[2].y);
      }
      else if(spin == 1){
        line(pos.x, pos.y, attractorsLeft[0].x, attractorsLeft[0].y);
        line(pos.x, pos.y, attractorsLeft[1].x, attractorsLeft[1].y);
        line(pos.x, pos.y, attractorsLeft[2].x, attractorsLeft[2].y);
      }
    }
  }
}

Atom[] atoms = new Atom[40];

void setup(){
  size(1000, 1000);
  
  for(int i=0; i<atoms.length;i++){
    PVector loc = new PVector(random(0,width), random(0,height));
    atoms[i] = new Atom(i, loc, i);
  }
}

void draw(){
  background(255);
  
  for(int i=0; i<atoms.length;i++){
    for(int j=0; j<atoms.length;j++){
      if(i!=j)
        atoms[i].interact(atoms[j]);
    }
    atoms[i].update();
    atoms[i].show();
  }
  
}
