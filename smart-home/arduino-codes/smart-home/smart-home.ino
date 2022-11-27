#include <Wire.h> //Library for I2C communication
#include "LiquidCrystal_I2C.h" //I2C LCD library
#include<Servo.h>
#include "DHT.h"
#include <SoftwareSerial.h>

// HC-SR04 : sonar sensor
#define TRIGPIN 5  
#define  ECHOPIN 6  

#define BUZZERPIN 12//pore dibo
#define FLAME_SENSORPIN 2
#define SMOKE_SENSOR_PIN A1

#define LED_PIN 13//pore dibo
#define LDR_PIN A0

// temperature and humidity sensor
#define DHTPIN 4 
#define DHTTYPE DHT11

#define SERVO_PIN 9
#define DOOR_OPEN_ANGLE 70
#define DOOR_CLOSE_ANGLE 140
#define RXgsm 10
#define TXgsm 11

const uint32_t GSMBaud = 115200;
SoftwareSerial gsmSerial(RXgsm, TXgsm);

long duration;
float distance;

int buzzerOn = 0;

bool autoOpenDoor = true;
bool ledOn = false;
bool ldrOn = true;
int ldrThreshold = 100;


//Bracket er moddhe prothom ta I2C Scanner code diye address ta scan kore niye boshabo, 
//ar baki duita LCD er dimension  
LiquidCrystal_I2C lcd(0x3F, 16, 2); // file/examples/wire/i2c_scanner

//servo configurations
Servo door_servo;
int pos=0; //Servo ke initially leftmost position e rakhlam

DHT dht(DHTPIN, DHTTYPE);

void sendMessage(String msg)
{
  gsmSerial.println("AT+CMGF=1");    //Sets the GSM Module in Text Mode
  delay(1000);  // Delay of 1000 milli seconds or 1 second
  gsmSerial.println("AT+CMGS=\"+88
\"\r"); // Replace x with mobile number
  delay(1000);
  Serial.print(" Sending SMS!");
  gsmSerial.println(msg);// The SMS text you want to send
  delay(100);
  gsmSerial.println((char)26);// ASCII code of CTRL+Z
  delay(1000);
}

void setup() {
  // put your setup code here, to run once:
   gsmSerial.begin(GSMBaud);
   
  Serial.begin(9600);
  
  pinMode(TRIGPIN,OUTPUT);
  pinMode(ECHOPIN,INPUT);
  pinMode(FLAME_SENSORPIN,INPUT);
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUZZERPIN,OUTPUT);

  lcd.begin();
  lcd.backlight();
  lcd.print("Measuring ");
  lcd.setCursor(2,3);
  lcd.print("temperature");
  delay(1000);
  lcd.clear();
  door_servo.attach(SERVO_PIN);

  dht.begin();
}

void listenAppInput(){
  if (Serial.available()) /* If data is available on serial port */
    {
      char data = Serial.read();
      Serial.print("input: ");
      Serial.println(data);

      switch (data) {
        case '0': {
          autoOpenDoor = false;
          door_servo.write(DOOR_CLOSE_ANGLE);
          break;
        }
        case '1': {
          autoOpenDoor = true;
          break;
        }
        case '2': {
          ledOn = true;
          ldrOn = false;
          Serial.println("LDR Off, LED On");
          break;
        }
        case '3': {
          ledOn = false;
          ldrOn = false;
          Serial.println("LDR Off, LED Off");
          break;
        }
        case '4':  {
          ledOn = false;
          ldrOn = true;
          Serial.println("LDR On with threshold " + ldrThreshold);
          break;
        }
        case '5':  {
          ldrOn = true;
          ldrThreshold = (char) Serial.read();
          ldrThreshold *= 8;
          Serial.println("LDR Threshold Changed to: " + (ldrThreshold));
          break;
        }
      }
    }
}

/**
 * https://howtomechatronics.com/tutorials/arduino/ultrasonic-sensor-hc-sr04/
 */
void openDoor(){
  digitalWrite(TRIGPIN,LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGPIN,HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGPIN,LOW);
  duration=pulseIn(ECHOPIN,HIGH);
  distance=duration*0.017;

  Serial.print("Distance: ");
  Serial.print(distance);
  Serial.print("\n");
  
  //door open er code
  //delay(500);
  door_servo.write(distance<10 ? DOOR_OPEN_ANGLE : DOOR_CLOSE_ANGLE);
}

void ldrLightControl(){
  //ldr portion
  int ldrvalue=analogRead(LDR_PIN);
  Serial.print("Ldr: ");
  Serial.print(ldrvalue);
  Serial.print("(");
  Serial.print(ldrThreshold);
  Serial.println(")");
  digitalWrite(LED_PIN, ldrvalue<ldrThreshold);
}

void alert(String op) {
  buzzerOn = max(buzzerOn, 5);
  digitalWrite(BUZZERPIN, buzzerOn);
  Serial.print(" Fire Alert!");
  door_servo.write(DOOR_OPEN_ANGLE);
  sendMessage(op+" detected in your house, emergency door open...");
  Serial.println("Alert: " + op+" detected in your house, emergency door open...");
}

void detectFire(){
   //flame sensor_eikhane kono analog output pin nai. tai arduino er digital pin ekta te input nibo
   //Flame sensor activate hoile 0 output dey ar naile 1 output dey
   int flame=digitalRead(FLAME_SENSORPIN);
   Serial.print("flame: ");
   Serial.print(flame);
   Serial.print("\n");
   delay(20);
   if (!flame)
    alert("Fire");
}


void detectSmoke(){
  //Smoke sensor

 int smoke=digitalRead(SMOKE_SENSOR_PIN);
 Serial.print("Smoke: ");
 Serial.print(smoke);
 Serial.print("\n");

 // Temparature Sensor er measurement er Code
  delay(20);
  if (!smoke)
    alert("Gas/Smoke");
}


void measureTemperatureAndHumidity(){
  ///////////////////// DHT //////////////////
 // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit (isFahrenheit = true)
  float f = dht.readTemperature(true);

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  // Compute heat index in Fahrenheit (the default)
  float hif = dht.computeHeatIndex(f, h);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(t, h, false);

  String btLog = String("Humidity: ");
  btLog.concat(h);
  Serial.println(btLog);
  btLog = "Temperature: ";
  btLog.concat(t);
  Serial.println(btLog);
  
  lcd.clear();
  lcd.print("Humidity:");
  lcd.print(h);
  lcd.setCursor(0, 1);
  lcd.print("Temp:");
  lcd.print(t);
  delay(1000);
}

void loop() {
  buzzerOn = buzzerOn ? buzzerOn-1 : 0;
  
  if (autoOpenDoor && !buzzerOn) openDoor();
  
  measureTemperatureAndHumidity();
  
  if (ldrOn) ldrLightControl();
  else digitalWrite(LED_PIN, ledOn);
  
  detectFire();
  detectSmoke();
  listenAppInput();
  
  digitalWrite(BUZZERPIN, buzzerOn);
  Serial.print("\n\n");
}
