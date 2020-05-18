import sprites.*;
import sprites.maths.*;
import sprites.utils.*;

int gameState = 0;
int score = 0;
int nextFrame = 0;
StopWatch sw = new StopWatch();
Sprite player;
Sprite warning;
Sprite wave;
Sprite endScreen;
Sprite playScreen;
Sprite batteryBack;
Sprite batteryPack;
Sprite magnet;
Sprite pickAxe;
Sprite ocean[];
Sprite forest[];
Sprite beach[];
Sprite lanes[];
ArrayList<Sprite> obstacles;
ArrayList<int[]> obstaclesXY;
ArrayList<String> obstaclesNames;
String[] peopleNames = {"Images\\DryingOff.png", "Images\\Flexing.png", "Images\\Unknown.png"};
int obstacleDifference = 5;
int timeSinceLastObstacle = 0;
int timeSinceLastBattery = 0;
int timeSinceLastTool = 0;
int nextObstacleTime;
int batteryLife;
boolean waterWarning = false;
boolean keyReset = true;
double timeCheck;
int loc;
boolean leftKeySet = false;
boolean rightKeySet = false;
boolean invulnerable = false;
int tool = 0;
int toolTime = 0;
boolean redraw = false;
boolean thrown = true;
int counter = 0;

void setup(){
  size(384, 512);
  player = new Sprite(this, "Images\\Player.png", 1, 2, 100);
  player.setXY(width/2, height - player.getWidth()/2);
  
  timeCheck = sw.getRunTime();
  
  //backgrounds
  beach = new Sprite[27];
  ocean = new Sprite[9];
  forest = new Sprite[9];
  lanes = new Sprite[34];
  for(int i = 0; i < 27; i++){
    beach[i] = new Sprite(this, "Images\\Sand.png", 1, 1, 0);
  }
  for(int i = 0; i < 9; i++){
    ocean[i] = new Sprite(this, "Images\\Ocean.png", 1, 2, 0);
    ocean[i].setFrameSequence(0, 1, 0.5);
  }
  for(int i = 0; i < 9; i++){
    forest[i] = new Sprite(this, "Images\\Forest.png", 1, 1, 0);
  }
  for(int i = 0; i < 34; i++){
    lanes[i] = new Sprite(this, "Images\\Lane.png", 1, 1, 0);
  }
  
  //obstacles
  obstacles = new ArrayList<Sprite>();
  obstaclesXY = new ArrayList<int[]>();
  obstaclesNames = new ArrayList<String>();
  nextObstacleTime = floor(random(-3, 4));
  warning = new Sprite(this, "Images\\Warning.png", 2, 1, 110);
  warning.setXY(96, height/2);
  magnet = new Sprite(this, "Images\\Magnet.png", 1, 1 , 90);
  magnet.setVelY(384);
  pickAxe = new Sprite(this, "Images\\Pickaxe.png", 1, 1, 90);
  pickAxe.setVelY(384);
  wave = new Sprite(this, "Images\\Wave.png", 2, 1, 80);
  endScreen = new Sprite(this, "Images\\GameOver.png", 1, 1, 200);
  endScreen.setXY(width/2, height/2);
  playScreen = new Sprite(this, "Images\\StartScreen.png", 1, 1, 200);
  playScreen.setXY(width/2, height/2);
  batteryBack = new Sprite(this, "Images\\BatteryBar.png", 1, 1, 150);
  batteryBack.setXY(64, 32);
  batteryPack = new Sprite(this, "Images\\BatteryPack.png", 1, 1, 90);
  batteryPack.setVelY(384);
  batteryPack.setVisible(false);
  warning.setVisible(false);
  wave.setVisible(false);
  wave.setVelXY(192, 384);
  wave.setFrameSequence(0, 1, 0.5);
  warning.setFrameSequence(0, 1, 0.5);
  wave.setVisible(false);
}

void draw(){
  background(255);
   //INITIALIZE
   if(gameState == 0){
     endScreen.setVisible(false);
     playScreen.setVisible(true);
     player.setXY(width/2, height - player.getWidth()/2);
     if(keyPressed && key == ENTER && keyReset){
       loc = 1;
       gameState = 1;
       invulnerable = false;
       score = 0;
       batteryLife = 120;
       timeCheck = sw.getRunTime();
       timeSinceLastObstacle = -5;
       timeSinceLastTool = -30;
       timeSinceLastBattery = -25;
       toolTime = floor(random(30, 35));
       thrown = false;
       tool = 0;
       counter = 0;
       redraw = false;
       player.setFrameSequence(0, 1, 0.25);
       wave.setVisible(false);
       wave.setX(120);
       warning.setVisible(false);
       batteryPack.setVisible(false);
       playScreen.setVisible(false);
       magnet.setVisible(false);
       pickAxe.setVisible(false);
       pickAxe.setRot(0);
       pickAxe.setVelY(384);
       magnet.setVelY(384);
       batteryPack.setVelXY(0, 384);
       
       for(int i = 0; i < 3; i++){
         for(int j = 0; j < 9; j++){
            beach[i + 3*j].setXY(96 + i * 96, -32 + j * 64);
            beach[i + 3*j].setVelY(384);
         }
       }
       for(int i = 0; i < 9; i++){
         ocean[i].setXY(32, -32 + i * 64);
         ocean[i].setVelY(384);
       }
       for(int i = 0; i < 9; i++){
         forest[i].setXY(width - 32, -32 + i * 64);
         forest[i].setVelY(384);
       }
       for(int i = 0; i < 2; i++){
         for(int j = 0; j < 17; j++){
            lanes[i + 2*j].setXY(144 + i * 96, -32 + j * 32);
            lanes[i + 2*j].setVelY(384);
         }
       }
     }
   }
   if(gameState == 1){
     //every .5
     if(sw.getRunTime() - timeCheck >= .166){
       timeSinceLastObstacle++;
       timeSinceLastBattery++;
       timeSinceLastTool++;
       counter++;
       batteryLife -= 1;
       timeCheck = sw.getRunTime();
       if(invulnerable){
         player.setVisible(!player.isVisible());
       } else {
         player.setVisible(true);
       }
       if(timeSinceLastObstacle >= 0 && invulnerable){
         invulnerable = false;
       }
       
     }
     
     
     for(int i = 0; i < 3; i++){
       for(int j = 0; j < 9; j++){
          if(beach[i + 3*j].getY() >= beach[i + 3*j].getHeight()/2 + height){
            beach[i + 3*j].setY(beach[(j == 8 ? 0 : j + 1)*3 + i].getY() -64);
          }
       }
     }
     for(int i = 0; i < 9; i++){
       if(ocean[i].getY() >= ocean[i].getHeight()/2 + height){
         ocean[i].setY(ocean[i == 8 ? 0 : i + 1].getY() -64);
       }
     }
     for(int i = 0; i < 9; i++){
       if(forest[i].getY() >= forest[i].getHeight()/2 + height){
         forest[i].setY(forest[i == 8 ? 0 : i + 1].getY() -64);
       }
     }
     for(int i = 0; i < 2; i++){
       for(int j = 0; j < 17; j++){
         if(lanes[i + 2*j].getY() >= lanes[i + 2*j].getHeight()/2 + height){
            lanes[i + 2*j].setY(lanes[(j == 16 ? 0 : j + 1)*2+i].getY() -32);
         }
       }
     }

     
     //PLAYER MOVEMENT
     if(leftKeySet == false && (keyCode == LEFT || key == 'a') && keyPressed){
       loc -= loc == 0 ? 0 : 1;
       leftKeySet = true;
     } else if (rightKeySet == false && (keyCode == RIGHT || key == 'd') && keyPressed){
       loc += loc == 2 ? 0 : 1;
       rightKeySet = true;
     }
     if(rightKeySet && ((keyCode != RIGHT && key != 'd') || !keyPressed)){
       rightKeySet = false;
     }
     if(leftKeySet && ((keyCode != LEFT && key != 'a') || !keyPressed)){
       leftKeySet = false;
     }
     if(96 + (96 * loc)-player.getX() < -5){
       player.setVelX(-384);
     } else if(96 + (96 * loc) - player.getX() > 5){
       player.setVelX(512);
     } else {
       player.setVelX(0);
     }
     
     //BATTERY PACK
     if(timeSinceLastBattery >= 25){
       timeSinceLastBattery = 0;
       batteryPack.setVisible(true);
       batteryPack.setXY(floor(random(3)) * 96 + 96, -32);
     }
     if(batteryPack.pp_collision(player)){
       batteryLife += batteryLife + 40 > 120 ? 120 - batteryLife : 40;
       batteryPack.setVelXY(0, 384);
       batteryPack.setVisible(false);
     }
     if((batteryPack.getHeight() / 2) + height <= batteryPack.getY()){
       batteryPack.setVisible(false);
       if(batteryPack.getVelY() > 384){
         batteryPack.setVelY(384);
         batteryLife += batteryLife + 40 > 120 ? 120 - batteryLife : 40;
       }
     }
     
     //TOOLS
     if(timeSinceLastTool > toolTime){
       timeSinceLastTool = 0;
       toolTime = floor(random(30, 45));
       if(tool == 0){
         int rando = floor(random(2));
         if(rando == 0){
           magnet.setVisible(true);
           magnet.setXY(floor(random(3)) * 96 + 96, -32);
         } else if (rando == 1){
           pickAxe.setVisible(true);
           pickAxe.setXY(floor(random(3)) * 96 + 96, -32);
         }
       }
     } 
     if(tool == 0){       
       if(magnet.pp_collision(player)){
         magnet.setXY(width - 32, 72);
         magnet.setVelXY(0, 0);
         tool = 1;
       }
       if(pickAxe.pp_collision(player)){
         pickAxe.setXY(width - 32, 72);
         pickAxe.setVelXY(0, 0);
         tool = 2;
       }
     }
     if(tool == 1){
       if(keyPressed && (key == 'z' || keyCode == UP)){
         magnet.setVisible(false);
         magnet.setVelY(384);
         tool = 0;
         if(batteryPack.getY() > 0 && batteryPack.getY() < height){
           batteryPack.setVelXY((player.getX() - batteryPack.getX())*6, (player.getY() - batteryPack.getY())*6);
         }
       }
     } else if(tool == 2) {
       if(keyPressed && (key == 'z' || keyCode == UP)){
         pickAxe.setXY(player.getX(), player.getY() - 64);
         pickAxe.setVelY(-384);
         thrown = true;
       }
       if(pickAxe.getY() <= -72){
         pickAxe.setVisible(false);
         pickAxe.setRot(0);
         thrown = false;
         tool = 0;
         pickAxe.setVelY(384);
       }
     }
     if(thrown){
       pickAxe.setRot((counter % 16) * PI/8);
     }
     
     //OBSTACLES
     generateRandomObstacle();
     for(int i = 0; i < obstacles.size(); i++){
       
       if(obstaclesNames.get(i) == "Tree"){
         if(obstacles.get(i).getY() > height * 3 / 4){
           obstacles.get(i).setFrame(2);
           obstacles.get(i).setX(240);
         }
         else{
           obstacles.get(i).setFrameSequence(0, 1, 0.5);
         }
       }
       if(obstacles.get(i).pp_collision(player) && !invulnerable){
         if(obstaclesNames.get(i) == "Person"){
           batteryLife = 0;
         } else {
           batteryLife -= batteryLife < 30 ? batteryLife : 30;
           invulnerable = true;
           timeSinceLastObstacle = -15;
           timeSinceLastBattery -= 15;
         }
       }
       if(obstacles.get(i).getY() >= obstacles.get(i).getHeight() + height){
         obstacles.remove(i);
         //obstaclesXY.remove(i);
         obstaclesNames.remove(i);
       }
       else if(obstacles.get(i).pp_collision(pickAxe) && tool == 2 && (obstaclesNames.get(i) == "Person" || obstaclesNames.get(i) == "Rock")){
         pickAxe.setVisible(false);
         pickAxe.setVelY(384);
         tool = 0;
         thrown = false;
         if(obstaclesNames.get(i) == "Person"){
           batteryLife = 0;
         } else {
           pickAxe.setRot(0);
           obstacles.get(i).setVisible(false);
           obstacles.remove(i);
           obstaclesNames.remove(i);
         }
       
       }
     }
     if(wave.pp_collision(player) && !invulnerable){
       batteryLife -= batteryLife < 30 ? batteryLife : 30;
       invulnerable = true;
       timeSinceLastObstacle = -8;
       timeSinceLastBattery -= 10;
     }
     if(redraw){
       delay(2000);
       gameState = 2;
     }
     if(batteryLife <= 0) {
       redraw = true;
     }
     if(waterWarning){
       warning.setVisible(true);
     }
     else{
       warning.setVisible(false);
     }
     if(wave.getX() > 96){
       wave.setVisible(false);
       waterWarning = false;
     }
     else{
       wave.setVisible(true);
     }
   } 
   if(gameState == 2) {
     obstacles.clear();
     obstaclesNames.clear();
     endScreen.setVisible(true);
     if(keyPressed && key == ENTER){
       gameState = 0;
       keyReset = false;
     }
   }
   if(!keyPressed){
     keyReset = true;
   }
   
   
   float elapsedTime = (float) sw.getElapsedTime();
   S4P.updateSprites(elapsedTime);
   S4P.drawSprites();
  // println(sw.getElapsedTime());
   
   
   //NON-SPRITE STUFF
   if(gameState == 1){
     //BATTERY
     fill(255, 0, 0);
     noStroke();
     rect(16, 16, (batteryLife * 96)/120, 32);
     
     //SCORING
     score++;
     textAlign(RIGHT);
     stroke(0);
     fill(0);
     text(score, 380, 10);
   }
   if(gameState == 2){
     textAlign(RIGHT);
     
     stroke(0);
     fill(0);
     textSize(45);
     text(score, 385, 485);
     
     textSize(12);
   }
}

void generateRandomObstacle(){
  if(obstacleDifference - timeSinceLastObstacle == nextObstacleTime){
    //println("HERE");
    nextObstacleTime = floor(random(2, 3));
    timeSinceLastObstacle = -1;
    int obstacleChoice = floor(random(4));
    if(waterWarning){
      obstacleChoice = floor(random(3));
    }
    //ROCKS
    if(obstacleChoice == 0){
      int ii = floor(random(5));
      int column = floor(random(3));
      int prevColumn = 4;
      for(int i = ii; i < 5; i++){
        obstacles.add(new Sprite(this, "Images\\Rock.png", 1, 1, 80));
        //obstaclesXY.add(new int[]{column * width/4 + width/6, -i*height/8 -height/8});
        obstaclesNames.add("Rock");
        obstacles.get(obstacles.size() - 1).setCollisionRadius(32);
        obstacles.get(obstacles.size() - 1).setXY(column * width/4 + width/4, -i*height/8 -height/16);
        obstacles.get(obstacles.size() - 1).setVisible(true);
        obstacles.get(obstacles.size() - 1).setVelY(384);
        timeSinceLastObstacle -= 1;
        if(column == 1 && prevColumn == 0){
          column = floor(random(2));
          prevColumn = column == 1 ? 0 : 1;
        } else if(column == 1 && prevColumn == 2){
          column = floor(random(2))+1;
          prevColumn = column == 1 ? 2 : 1;
        } else {
          prevColumn = column;
          column = floor(random(3));
        }
      }
    }
    //TREE
    if(obstacleChoice == 1){
      obstacles.add(new Sprite(this, "Images\\Tree.png", 2, 2, 80));
      obstacles.get(obstacles.size() - 1).setXY(width + 48, -80);
      obstacles.get(obstacles.size() - 1).setVelY(384);
      obstaclesNames.add("Tree");
    }
    //HUMAN
    if(obstacleChoice == 2){
      obstacles.add(new Sprite(this, peopleNames[/*floor(random(3))*/0], 1, 1, 80));
      obstacles.get(obstacles.size() - 1).setXY(floor(random(3)) * width/4 + width/4, -height/16);
      obstacles.get(obstacles.size() - 1).setVelY(384);
      obstaclesNames.add("Person");
    }
    //WATER
    if(obstacleChoice == 3){
      timeSinceLastObstacle = -1;
      waterWarning = true;
      wave.setXY(-192, -64);
    }
  }
}