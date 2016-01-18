import processing.io.*;

int stage = 0;
ArrayList<PImage> images;
PImage backgroundImg, resultImg;
String s2String, saveLoc;
float bloodY, bloodYInc;
PFont regF, ordF;
int stage3Timer;
int inputPin = 4;
int outputPin = 17;


void setup() {

  GPIO.pinMode(inputPin, GPIO.INPUT);
  GPIO.pinMode(outputPin, GPIO.OUTPUT);

  //HVOR BILLEDERNE SKAL GEMMES
  //saveLoc = "C:\\Users\\N\\Desktop\\blodsBilleder";
  saveLoc = "/home/pi";

  //Indsæt font til normal tekst
  regF = loadFont("GTWalsheim-BoldOblique-100.vlw");
  //Indsæt font til det input-ordet
  ordF = loadFont("GTWalsheim-BoldOblique-100.vlw");

  //size(1024, 768);
  fullScreen();
  background(255, 255, 255);

  images = new ArrayList<PImage>();
  for (int i = 0; i < 26; i++) {
    String temp = new String(Character.toChars(i+65));
    images.add(loadImage("img" + temp +".png"));
  }
  images.add(loadImage("imgAE.png"));
  images.add(loadImage("imgOE.png"));
  images.add(loadImage("imgAA.png"));
  images.add(loadImage("imgPU.png"));


  backgroundImg = loadImage("billede1.png");
  bloodY = height;
  bloodYInc = 15;
  s2String = "";
}


void draw() {
  background(255);
  show();
}

void show() {
  switch(stage) {
  case 0:
    if (GPIO.digitalRead(inputPin) == GPIO.LOW && s2String.length() != 0) {
      nextStage();
    } else {
      showText();
    }
    break;

  case 1:
    showText();
    fill(#b22020);
    noStroke();
    rect(0, bloodY, width, height + 10);
    bloodY -= bloodYInc;
    if (bloodY < 0) {
      nextStage();
    }
    break;
  case 2:
    showResult();
    fill(#b22020);
    noStroke();
    rect(0, bloodY, width, height + 10);
    bloodY += bloodYInc;
    if (bloodY > height) {
      nextStage();
    }
    break;

  case 3:
    showResult();
    break;
  }
}

void nextStage() {
  switch(stage) {
  case 0:
    createSaveImage();
    GPIO.digitalWrite(outputPin, GPIO.HIGH);
    break;

  case 1:
    GPIO.digitalWrite(outputPin, GPIO.LOW);
    break;

  case 2:
    stage3Timer = millis();
    break;

  case 3:
    s2String = "";
    break;
  }
  stage++;
  stage %= 4;
}

void showResult() {
  imageMode(CENTER);
  image(resultImg, width/2, height/2);

  fill(0);
  stroke(0);
  textFont(regF, 40);
  //RET TIL SÅ TEKSTEN STÅR DET RIGTIGE STED
  textAlign(CENTER);
  text("Dette billede blev skabt af ordet", 512, 650);

  textFont(ordF, 70);
  //RET TIL SÅ TEKSTEN STÅR DET RIGTIGE STED
  textAlign(CENTER);
  text(s2String.toUpperCase(), 512, 740);
}

void showText() {
  imageMode(CORNER);
  image(backgroundImg, 0, 0);
  textFont(ordF, 100);
  stroke(0);
  fill(0);
  text(s2String.toUpperCase(), width/2 - textWidth(s2String)/2, height/2);
}

void createSaveImage() {
  resultImg = createImage(600, 600, ARGB);
  for (char c : s2String.toCharArray()) {
    PImage letterImg = getImg(c);
    resultImg.blend(letterImg, 0, 0, 600, 600, 0, 0, 600, 600, LIGHTEST);
  }
  resultImg.save(saveLoc + "\\" + getName() + "_" + s2String + ".png");
}

PImage getImg(char ch) {
  char c = Character.toUpperCase(ch);
  PImage img = images.get(26);
  if (c == 'Æ') {
    img = images.get(26);
  } else if (c == 'Ø') {
    img = images.get(27);
  } else if (c == 'Å') {
    img = images.get(28);
  } else if (c == '.' || c == ':') {
    img = images.get(29);
  } else {
    int j = Character.valueOf(c) - 64;
    if (j >= 0 && j <= 26) {
      img = images.get(j);
    }
  }
  return img;
}

void keyTyped() {
  switch(stage) {
  case 0:
    if (key == BACKSPACE && s2String.length() > 0) {
      s2String = s2String.substring(0, s2String.length()-1);
    } else if (Character.isLetter(key)) {
      s2String += key;
    }
    break;
  case 3:
    if (key == ENTER || key == RETURN || key == ' ') {
      nextStage();
    }
    break;
  }
}

String getName() {
  String s = year() + "_";
  s += month() + "_";
  s += day() + "_";
  s += hour() + "_";
  s += second();
  return s;
}
