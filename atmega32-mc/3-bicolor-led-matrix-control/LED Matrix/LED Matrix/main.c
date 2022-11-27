/*
 * LED Matrix.c
 *
 * Created: 19-Jun-22 11:21:35 AM
 * Author : Masum
 */ 

#include <avr/io.h>
#define F_CPU 1000000 // Clock Frequency
#include <util/delay.h>



int main(void)
{
    uint8_t matrix[] = {0x7E,0x7E,0x18,0x18,0x18,0x18,0x18,0x18};
	DDRC = 0xFF;
	DDRD = 0xFF;
	// fuck mehedi
	uint8_t c = 1, i = 0;
    while (1) 
    {
		PORTC = c;
		PORTD = ~matrix[i];
		i = (i+1)%8;		
		_delay_ms(2);
		c <<= 1;
		if (!c) {
			PORTC = c;
			for(int j = 0; j < 8; j++){
				char t = matrix[j] & 0x01;
				matrix[j] >>= 1;
				matrix[j] = matrix[j] | (t << 7);
				//_delay_ms(200);
			}
			_delay_ms(25);
			
			c = 1;
		}
    }
}

/*
int main(){
	DDRC = 0xFF;
	DDRD = 0xFF;
	
	while(1){
		PORTC = 0xFF;
		PORTD = 0x00;
	}
}
	*/
