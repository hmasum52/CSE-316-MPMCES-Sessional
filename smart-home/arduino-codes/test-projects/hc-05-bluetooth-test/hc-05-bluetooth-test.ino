
/* Create object named bt of the class SoftwareSerial */ 

void setup() {
  Serial.begin(9600); /* Define baud rate for serial communication */
  pinMode(12,OUTPUT); // https://forum.arduino.cc/t/getting-low-voltage-from-digital-pin-1-7v-instead-of-5v/191651/2

}

void loop() {
  
    if (Serial.available()) /* If data is available on serial port */
    {
      int data = Serial.read();
      Serial.print("input: ");
      Serial.println(data);
      digitalWrite(12, data == '1' ? LOW : HIGH);
    }
}
