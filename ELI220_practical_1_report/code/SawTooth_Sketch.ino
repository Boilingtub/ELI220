// ESP32 Sawtooth Signal Generator
// Period T = 1 second
// Uses DAC output on GPIO25 for true analog output

#define DAC_PIN 25        
#define PERIOD_MS 1000    // Period, T : ADJUST HERE NOT LOCALLY
#define DAC_MAX 78
#define LED_PIN 2

unsigned long startTime;
unsigned long currentTime;
unsigned long lastPrintTime = 0;
unsigned long lastLedToggle = 0;
bool ledState = false;

void setup() {
  Serial.begin(115200);  // Changed to faster baud rate for better performance
  
  // Initialize DAC pin
  pinMode(DAC_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
  
  // Record start time
  startTime = millis();
  
  Serial.println("ESP32 Sawtooth Generator Started");
  Serial.println("Output Pin: GPIO25 (DAC)");
  Serial.println("Period: 1 second");
  Serial.println("Frequency: 1 Hz");
  Serial.println("Max output: 3.3V (DAC range 0-255)");
}

void loop() {
  currentTime = millis();
  
  // Calculate time within current period (0 to PERIOD_MS)
  unsigned long timeInPeriod = (currentTime - startTime) % PERIOD_MS;
  
  // Calculate sawtooth value (0 to DAC_MAX)
  // Linear ramp from 0 to maximum over the period
  int sawtoothValue = (timeInPeriod * DAC_MAX) / PERIOD_MS;
  
  // Output to DAC continuously
  dacWrite(DAC_PIN, sawtoothValue);
  
  // Handle LED blinking without blocking delays
  if (currentTime - lastLedToggle >= 500) {  // Toggle every 500ms for 1Hz blink
    ledState = !ledState;
    digitalWrite(LED_PIN, ledState);
    lastLedToggle = currentTime;
  }
  
  // Print values for debugging every 100ms
  if (currentTime - lastPrintTime >= 100) {
    Serial.print("Time in period: ");
    Serial.print(timeInPeriod);
    Serial.print(" ms, DAC value: ");
    Serial.print(sawtoothValue);
    Serial.print(" (");
    Serial.print((sawtoothValue * 3.3) / 255.0, 2);  // Show voltage
    Serial.println("V)");
    lastPrintTime = currentTime;
  }
  
  // Small delay for stability
  delayMicroseconds(100);
}