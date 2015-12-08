boolean stage1, stage2, stage3, stage4;
ArrayList<PImage> images;
PImage i1, i2, i3, i2p, i4;
String s2String, saveLoc;
float s3y;
PFont regF, ordF;
int buffer;
 
 
void setup() {
 
  //HVOR BILLEDERNE SKAL GEMMES
  saveLoc = "C:\\Users\\Nikolaj\\Desktop\\gemBilleder\\";
 
  //Indsæt font til normal tekst
  regF = loadFont("GTWalsheim-BoldOblique-100.vlw");
  //Indsæt font til det input-ordet
  ordF = loadFont("GTWalsheim-BoldOblique-100.vlw");
 
  size(1024, 768);
  background(255, 256, 255);
 
  images = new ArrayList<PImage>();
  for (int i = 0; i < 26; i++) {
    String temp = new String(Character.toChars(i+65));
    images.add(loadImage("img" + temp +".png"));
  }
  images.add(loadImage("imgAE.png"));
  images.add(loadImage("imgOE.png"));
  images.add(loadImage("imgAA.png"));
  images.add(loadImage("imgPU.png"));
 
  i1 = loadImage("billede1.png");
  i2 = loadImage("billede4.png");
  i3 = loadImage("billede3.png");
  i2p = loadImage("billede2.png");
 
  changeStage(1);
}
 
void draw() {
 
  if (stage4) {
    if (s3y <= height) {
      background(255);
      imageMode(CENTER);
      image(i4, width/2, height/2);
      fill(0);
 
      noStroke();
      fill (#b22020);
      rect(0, (int)s3y, width, height);
 
      fill(0);
      textFont(regF, 40);
      //RET TIL SÅ TEKSTEN STÅR DET RIGTIGE STED
      textAlign(CENTER);
      text("Dette billede blev skabt af ordet", 512, 650);
 
      textFont(ordF, 70);
      //RET TIL SÅ TEKSTEN STÅR DET RIGTIGE STED
      textAlign(CENTER);
      text(s2String.toUpperCase(), 512, 740);
      //hastigheden på blodet
      s3y += 2.0;
    } 
    else {
      if (millis() - buffer > 30000) {
        changeStage(1);
      }
    }
  }
  else if (stage3) {
    if (s3y > 0) {
      background(255);
      noStroke();
      fill (#b22020);
      rect(0, (int)s3y, width, height);
      image(i3, 0, 0);
 
      //hastigheden på blodet
      s3y -= 2.0;
    } 
    else {
      changeStage(4);
    }
  } 
  else if (stage2) {
    image(i2, 0, 0);
    fill(0);
    textFont(ordF, 100);
 
    text(s2String.toUpperCase(), width/2 - textWidth(s2String)/2, height/2);
  }
}
 
//ÆNDRER STAGE I PROGRAMMET GIV TRUE TIL DET STAGE DER SKAL STARTES OG FALSE TIL DE ANDRE. HVIS DER FINDES FLERE 'TRUE' TAGER DET FØRSTE I RÆKKEN PRIORITET
void changeStage(int stg) {
  switch(stg)
  {
  case 1:
    {
      stage4 = false;
      stage1 = true;
      imageMode(CORNER);
      image(i1, 0, 0);
      s3y = height;
      s2String = "";
    }
    break;
  case 2:
    {
      stage1 = false;
      stage2 = true;
      image(i2, 0, 0);
    }
    break;
  case 3:
    {
      stage2 = false;
      stage3 = true;
      background(255);
    }
    break;
  case 4:
    {
      stage3 = false;
      stage4 = true;
      createSaveImage();
      buffer = millis();
    }
  }
}
 
void createSaveImage() {
  PImage rI = createImage(600, 600, ARGB);
  for (char c : s2String.toCharArray()) {
    PImage tI = getImg(c);
    rI.blend(tI, 0, 0, 600, 600, 0, 0, 600, 600, LIGHTEST);
  }
  String name = saveLoc + "_" + getName() + "_" + s2String + ".png";
  rI.save(name);
  i4 = rI;
  imageMode(CORNER);
}
 
PImage getImg(char ch) {
  char c = Character.toUpperCase(ch);
  PImage temp = images.get(26);
  if (c == 'Æ') {
    temp = images.get(26);
  } 
  else if (c == 'Ø') {
    temp = images.get(27);
  } 
  else if (c == 'Å') {
    temp = images.get(28);
  } 
  else if (c == '.' || c == ':') {
    temp = images.get(29);
  }
  else {
    int j = Character.valueOf(c) - 64;
    if (j >= 0 && j <= 26) {
      temp = images.get(j);
    }
  }
  return temp;
}
 
void keyTyped() {
  if (stage1) {
    if (key == ENTER || key == RETURN) {
      changeStage(2);
    }
  }
  else if (stage2) {
    if (key == BACKSPACE) {
      if (s2String.length() > 0) {
        s2String = s2String.substring(0, s2String.length()-1);
      }
    } 
    else if (key == ENTER || key == RETURN) {
      if(s2String.length() != 0){
        changeStage(3);
      }
    } 
    else {
      if (Character.isLetter(key)) {
        s2String += key;
      }
    }
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
