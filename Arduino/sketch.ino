const int buttonPin = 2;
const int buttonPin2 = 7;


void setup() {
  // put your setup code here, to run once:


 pinMode(buttonPin, INPUT); 
 pinMode(buttonPin2, INPUT);  

 Serial.begin(9600);
 // initialize the pushbutton pin as an input:


}

void loop() {
 
if (digitalRead (2) == 1 && digitalRead (7) == 1)
  { 
    Serial.println(digitalRead(2));
    //Serial.println(digitalRead(7));
    delay(1000);
  }
  
  //delay(2);
}
