#include <WiFi.h>
#include <FirebaseESP32.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// WiFi & Firebase
#define WIFI_SSID "Uzyyy"
#define WIFI_PASSWORD "uzman2005"
#define FIREBASE_HOST "https://leakguardorg-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define FIREBASE_AUTH "AIzaSyC4lzEbxLTRDdUCU-1RwQdJ3c6U5gmm0C4"

FirebaseData firebaseData;
FirebaseJson json;
FirebaseConfig config;
FirebaseAuth auth;

// Flow Sensors
#define FLOW_SENSOR_1 13
#define FLOW_SENSOR_2 12
#define FLOW_SENSOR_3 26
#define FLOW_SENSOR_4 25

// Relays (Active LOW)
#define RELAY_1 15
#define RELAY_2 2

// Ultrasonic
#define ULTRASONIC_TRIG 18
#define ULTRASONIC_ECHO 19

// DS18B20 Temperature
#define ONE_WIRE_BUS 5
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

// Tank height
#define MAX_TANK_HEIGHT 30.0

// Global variables
volatile int flowPulse1 = 0, flowPulse2 = 0, flowPulse3 = 0, flowPulse4 = 0;
float flowRate1, flowRate2, flowRate3, flowRate4;
float waterTemperature;
float waterLevel;
float leakSensitivity = 5.0; // Default leak sensitivity in L/min

void IRAM_ATTR countFlow1() { flowPulse1++; }
void IRAM_ATTR countFlow2() { flowPulse2++; }
void IRAM_ATTR countFlow3() { flowPulse3++; }
void IRAM_ATTR countFlow4() { flowPulse4++; }

void setup() {
  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println("\n✅ Connected to WiFi");

  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  Serial.println("✅ Firebase initialized");

  // Flow sensor pins
  pinMode(FLOW_SENSOR_1, INPUT_PULLUP);
  pinMode(FLOW_SENSOR_2, INPUT_PULLUP);
  pinMode(FLOW_SENSOR_3, INPUT_PULLUP);
  pinMode(FLOW_SENSOR_4, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_1), countFlow1, RISING);
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_2), countFlow2, RISING);
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_3), countFlow3, RISING);
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_4), countFlow4, RISING);

  // Relays
  pinMode(RELAY_1, OUTPUT);
  pinMode(RELAY_2, OUTPUT);
  digitalWrite(RELAY_1, HIGH); // OFF by default (valve open)
  digitalWrite(RELAY_2, HIGH);

  // Ultrasonic
  pinMode(ULTRASONIC_TRIG, OUTPUT);
  pinMode(ULTRASONIC_ECHO, INPUT);

  sensors.begin();
}

void loop() {
  // Calculate flow rate (pulses per 5 sec)
  flowRate1 = (flowPulse1 * 12.0) / 7.5;
  flowRate2 = (flowPulse2 * 12.0) / 7.5;
  flowRate3 = (flowPulse3 * 12.0) / 7.5;
  flowRate4 = (flowPulse4 * 12.0) / 7.5;

  flowPulse1 = flowPulse2 = flowPulse3 = flowPulse4 = 0;

  // Water Level via Ultrasonic
  digitalWrite(ULTRASONIC_TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(ULTRASONIC_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(ULTRASONIC_TRIG, LOW);

  long duration = pulseIn(ULTRASONIC_ECHO, HIGH);
  waterLevel = duration * 0.034 / 2;
  float waterLevelPercentage = 100.0 - ((waterLevel / MAX_TANK_HEIGHT) * 100.0);
  waterLevelPercentage = constrain(waterLevelPercentage, 0.0, 100.0);

  // Water Temperature
  sensors.requestTemperatures();
  waterTemperature = sensors.getTempCByIndex(0);

  // Fetch control values from Firebase
  String valveStatus = "open";
  if (Firebase.getString(firebaseData, "/control/main_valve_status")) {
    valveStatus = firebaseData.stringData();
  }

  if (Firebase.getFloat(firebaseData, "/control/leak_sensitivity")) {
    leakSensitivity = firebaseData.floatData();
  }

  // Leak Detection using dynamic sensitivity
  bool leak1 = abs(flowRate1 - flowRate2) > leakSensitivity;
  bool leak2 = abs(flowRate3 - flowRate4) > leakSensitivity;

  // Manual override
  if (valveStatus == "closed") {
    digitalWrite(RELAY_1, LOW);
    digitalWrite(RELAY_2, LOW);
  } else {
    digitalWrite(RELAY_1, leak1 ? LOW : HIGH);
    digitalWrite(RELAY_2, leak2 ? LOW : HIGH);
  }

  // Debugging
  Serial.println("Flow1: " + String(flowRate1) + " L/min");
  Serial.println("Flow2: " + String(flowRate2) + " L/min");
  Serial.println("Flow3: " + String(flowRate3) + " L/min");
  Serial.println("Flow4: " + String(flowRate4) + " L/min");
  Serial.println("Leak1: " + String(leak1));
  Serial.println("Leak2: " + String(leak2));
  Serial.println("Temp: " + String(waterTemperature) + " °C");
  Serial.println("Water Level: " + String(waterLevelPercentage) + " %");
  Serial.println("Valve Control (Firebase): " + valveStatus);
  Serial.println("Leak Sensitivity: " + String(leakSensitivity) + " L/min");
  Serial.println("-----------------------------");

  // Send to Firebase
  json.clear();
  json.add("flow_rate_1", flowRate1);
  json.add("flow_rate_2", flowRate2);
  json.add("flow_rate_3", flowRate3);
  json.add("flow_rate_4", flowRate4);
  json.add("water_temperature", waterTemperature);
  json.add("water_level", waterLevelPercentage);
  json.add("leak_status", (leak1 || leak2) ? "leak_detected" : "no_leak");

  if (Firebase.updateNode(firebaseData, "/water_system", json)) {
    Serial.println("✅ Firebase updated");
  } else {
    Serial.println("❌ Firebase update failed: " + firebaseData.errorReason());
  }

  delay(5000);  // wait 5 seconds
}

