/*
 * A2-G4-Counter.c
 * 4 bit down counter(PULL down)
 * push button pin PA4
 * output pin PD4 to PD7
 *
 * Created: 12-Jun-22 8:06:51 PM
 * Author : Hasan Masum
 */ 

#include <avr/io.h>
#define F_CPU 1000000 // Clock Frequency
#include <util/delay.h>


int main(void)
{
	// set push button input pin to PA4
	// PA4 is connected with push button: 1 when pressed
	DDRA = 0xEF; // 1110 1111
	
	// set all PDx to output
	// PORT D is connected to 4 LEDS(PD4 to PD7)
	DDRD = 0xFF; // 1111 1111
	
	uint8_t cnt = 15; // start counting from 15
	uint8_t in; // 1 if push button is pressed.
	
    while (1) 
    {
		// output current value of the counter to PORT D 
		PORTD = cnt << 4; // left shit 4 bit to show output in PD4 to PD7
		
		// check if push button is pushed in PIN PA4
		in = PINA & (0x10) ; // PINA & (0001 0000)
		
		if(in){
			
			// decrement count
			// cnt is set to 15 when it becomes -1
			cnt = (16+cnt-1)%16; 
			_delay_ms(1000);
		}
    }
}

