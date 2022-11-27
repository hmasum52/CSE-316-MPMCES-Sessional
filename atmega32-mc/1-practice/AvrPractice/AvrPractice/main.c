/*
 * AvrPractice.c
 *
 * Created: 19-Jun-22 7:57:55 PM
 * Author : Hasan Masum
 */ 

#include <avr/io.h>
#define F_CPU 1000000 // Clock Frequency
#include <util/delay.h>

int main(void){
	DDRA = 0xFF;
	DDRD = 0xFF;

	
	while(1){
		PORTA = 0xFF;
		PORTD = 0;
		_delay_ms(500);
	}
}

/*
int main(void){
	DDRA = 0xFF;
	DDRD = 0xFF;

	uint8_t c = 1;
	
	while(1){
		
		if(c){
			c=0;
			PORTA = 0xFF;
			PORTD = 0;
		}else{ 
			c=1;
			PORTA = 0;
			PORTD = 0;
		}
		_delay_ms(500);
	}
}*/

/*int main(void)
{
	DDRB = 0x01; // SET PB0 to output
	
	uint8_t c = 1;
	
    while(1)
    {
	    PORTB = c;
	    if(c)c=0;
	    else c=1;
	    _delay_ms(1000);
    }

}*/

