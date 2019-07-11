class Atom{
  Atom[] bond = new Atom[3];
  color rang;
  int id, spin = -1, bondIdx;
  boolean still = false;
  PVector pos,vel,acc;
  
  float G = 0.5;
  int bondSize = 40;
  
  boolean[] hasBond = new boolean[3];
  PVector[] attractorsLeft = new PVector[3];
  PVector[] attractorsRight = new PVector[3];
  
  Atom(int id, PVector pos, color rang, int spin){
    this.id = id;
    this.pos = pos;
    this.rang = rang;
    this.spin = spin;
    
    vel = new PVector();
    acc = new PVector();
    
    for(int i = 0; i < 3; i++){
      hasBond[i] = false;  
      bond[i] = null;
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
    vel.add(acc);
    vel.limit(1);
    pos.add(vel);
    acc.mult(0);
    this.updateAttractors();
    this.updateLinked(this);
  }
  
  void updateLinked(Atom atom){
    for (int i=0; i<3; i++){
      if(this.bond[i] != null){
        if(!(this.bond[i].vel == atom.vel && this.bond[i].acc == atom.acc) || !(this.bond[i].pos == atom.attractorsRight[i] || this.bond[i].pos == atom.attractorsLeft[i])){
          this.bond[i].vel = atom.vel;
          this.bond[i].acc = atom.acc;
          this.bond[i].pos = atom.spin==0?atom.attractorsRight[i]:atom.attractorsLeft[i];
          this.bond[i].updateLinked(this.bond[i]);
        }
      }
    }
  }
  
  void interact(Atom atom){
    
      if(atom.spin != this.spin){
        for(int i=0;i<3;i++){
          if(atom.spin == 1 && !atom.hasBond[i] && !this.hasBond[i]){
            if(PVector.sub(atom.attractorsLeft[i],this.pos).mag() < 20){
              this.pos = atom.attractorsLeft[i];
              this.still = true;
              atom.still = true;
              this.vel = atom.vel;
              this.acc = atom.acc;
              atom.hasBond[i] = true;
              this.bond[i] = atom;
              atom.bond[i] = this;
              this.updateLinked(this);
              break;
            }
          }else if(atom.spin == 0 && !atom.hasBond[i] && !this.hasBond[i]){
            if(PVector.sub(atom.attractorsRight[i],this.pos).mag() < 20){
              this.pos = atom.attractorsRight[i];
              this.still = true;
              atom.still = true;
              this.vel = atom.vel;
              this.acc = atom.acc;
              atom.hasBond[i] = true;
              this.bond[i] = atom;
              atom.bond[i] = this;
              this.updateLinked(this);
              break;
            }
          }
        }
      }else{
        
      }
      if(!this.still){
        PVector force = PVector.sub(atom.pos, this.pos);
        float d = force.mag();
        d = constrain(d,1,25);
        float attraction = G/(d*d);
        force.setMag(attraction);
        acc.add(force);
      }
  }
  
  void checkLimits(){
    if(pos.x > width-20){
      pos.x = 20;
    }
    if(pos.y > height-20){
      pos.y = 20;
    }
    if(pos.x < 20){
      pos.x = width - 20;
    }
    if(pos.y < 20){
      pos.y = height - 20;
    }
  }
  
  void show(){
    fill(rang);
    ellipse(pos.x, pos.y, 8, 8);
    if(spin != -1 && still){
      if(spin == 0){
        for(int i = 0; i<3; i++){
          if(this.bond[i] != null){
            stroke(#FF0000);
          }
          line(pos.x, pos.y, attractorsRight[i].x, attractorsRight[i].y);
          
          stroke(#000000);
        }
      }
      else if(spin == 1){
        for(int i = 0; i<3; i++){
          if(this.bond[i] != null){
            stroke(#FF0000);
          }
          line(pos.x, pos.y, attractorsLeft[i].x, attractorsLeft[i].y);
          
          stroke(#000000);
        }
      }
    }
  }
}

Atom[] atoms = new Atom[18];

void setup(){
  size(1000, 1000);
  
  for(int i=0; i<atoms.length;i++){
    PVector loc = new PVector(random(0,width), random(0,height));
    atoms[i] = new Atom(i, loc, i, i%2);
    atoms[i].updateAttractors();
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
