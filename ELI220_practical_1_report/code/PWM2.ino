const int outputPin = 2;     
float dutyCycle = 10.0;   // Dutycycle in %     

const unsigned long period = 1000;  // Total period in ms

void setup() {
  pinMode(outputPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("Square Wave Generator Started");
  Serial.print("Duty Cycle: ");
  Serial.print(dutyCycle);
  Serial.println("%");
}

void loop() {
  unsigned long highTime = (period * dutyCycle) / 100;
  unsigned long lowTime = period - highTime;
  
  digitalWrite(outputPin, HIGH);
  delay(highTime);
  
  digitalWrite(outputPin, LOW);
  delay(lowTime);
}