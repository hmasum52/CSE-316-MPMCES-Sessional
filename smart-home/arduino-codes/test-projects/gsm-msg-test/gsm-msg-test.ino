#include <SoftwareSerial.h>

#define RXgsm 10
#define TXgsm 11

const uint32_t GSMBaud = 115200;
SoftwareSerial gsmSerial(RXgsm, TXgsm);

void sendMessage(String msg)
{
  gsmSerial.println("AT+CMGF=1");    //Sets the GSM Module in Text Mode
  delay(1000);  // Delay of 1000 milli seconds or 1 second
  gsmSerial.println("AT+CMGS=\"+8801XXXXXXXXX\"\r"); // Replace x with mobile number. +880 is the country code for bangladesh
  delay(1000);
  Serial.print(" Sending SMS!");
  gsmSerial.println(msg);// The SMS text you want to send
  delay(100);
  gsmSerial.println((char)26);// ASCII code of CTRL+Z
  delay(1000);
}


void setup()
{
  gsmSerial.begin(GSMBaud);
  Serial.begin(9600);    // Setting the baud rate of Serial Monitor (Arduino)
  delay(100);
  sendMessage("Hello from the other side!");
}


void loop()
{
}
