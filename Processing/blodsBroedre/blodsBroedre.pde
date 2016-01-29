import processing.io.*;

int stage = 0;
ArrayList<PImage> images;
PImage backgroundImg, resultImg;
String s2String, saveLoc;
float bloodY, bloodYInc;
PFont font;
int inputPin = 4;
int outputPin = 17;
int secondsAtResultscreenStart;
//The amount of seconds the last screen with the users phrase and the resulting image will last
//last before switching to the first screen keep <= 59 or bad things will happen.
int resultScreenDelay = 30;


void setup() {

  GPIO.pinMode(inputPin, GPIO.INPUT);
  GPIO.pinMode(outputPin, GPIO.OUTPUT);

  //HVOR BILLEDERNE SKAL GEMMES
  //saveLoc = "C:\\Users\\N\\Desktop\\blodsBilleder";
  saveLoc = "/home/pi";

  //Indsæt font til normal tekst
  font = loadFont("GTWalsheim-BoldOblique-100.vlw");

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
  backgroundImg.resize(width/2, height/2);
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
    pushStyle();
    fill(#b22020);
    noStroke();
    rect(0, bloodY, width, height + bloodYInc);
    popStyle();
    bloodY -= bloodYInc;
    if (bloodY < 0) {
      nextStage();
    }
    break;
  case 2:
    showResult();
    pushStyle();
    fill(#b22020);
    noStroke();
    rect(0, bloodY, width, height + bloodYInc);
    popStyle();
    bloodY += bloodYInc;
    if (bloodY > height) {
     nextStage();
    }
    break;

  case 3:
    showResult();
    if(second()<(secondsAtResultscreenStart+resultScreenDelay)%59){ //modulo 59 means it counts to 59 and starts back at 0, so 50+30=20
      nextStage();
    }
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
    secondsAtResultscreenStart = second();
    break;

  case 3:
    s2String = "";
    break;
  }
  stage++;
  stage %= 4;
}

void showText() {
  pushStyle();
  textAlign(CENTER);
  imageMode(CENTER);
  image(backgroundImg, width/2, height/2);
  textFont(font, 100);
  stroke(0);
  fill(0);
  text(s2String.toUpperCase(), (width/2), height/2);
  textFont(font, 40);
  text("Sæt ord på jeres venskab", width/2, height * 0.2);
  text("Tryk på nålene når i er klar", width/2, height*0.875);
  popStyle();
}

void showResult() {
  pushStyle();
  imageMode(CENTER);
  image(resultImg, width/2, height/2);

  fill(0);
  stroke(0);
  textFont(font, 40);
  //RET TIL SÅ TEKSTEN STÅR DET RIGTIGE STED
  textAlign(CENTER);
  text("Dette billede blev skabt af ordet", (width/2), height*0.25);

  textFont(font, 70);
  //RET TIL SÅ TEKSTEN STÅR DET RIGTIGE STED
  textAlign(CENTER);
  text(s2String.toUpperCase(), width/2, height*0.75);
  popStyle();
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