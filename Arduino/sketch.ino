
#define MAX_ACTIVATION_TIME 30000 //miliseconds

const int inputPin = 2;
const int outputPin = 13;
unsigned long timeAtActivation=0;

void setup() {
 pinMode(inputPin, INPUT);
 pinMode(outputPin, OUTPUT);
 digitalWrite(outputPin,LOW); //start deactivated
}

void loop() {

	while(!digitalRead()); //while low.
	delay(20); //debounce .. probably not needed
	timeAtActivation=millis();
	digitalWrite(outputPin,HIGH); //activate
	while(digitalRead() && millis()<timeAtActivation+MAX_ACTIVATION_TIME); //while high && while MAX_ACTIVATION_TIME is not exceeded
	digitalWrite(outputPin,LOW); //deactivate

}
