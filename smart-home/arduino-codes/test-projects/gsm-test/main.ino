void send_message(String message)
{
    Serial.println("AT+CMGF=1");
    delay(100);
    SIM900.println("AT+CMGS=\"+916209403151\""); // Replace it with your number
    delay(100);
    SIM900.println(message);
    delay(100);
    SIM900.println((char)26);
    delay(100);
    SIM900.println();
    delay(1000);
}

void setup(){
    Serial.begin(9600);
    Serial.println("Hello World!");
}

void loop(){
    Serial.println("Hello World!");
}