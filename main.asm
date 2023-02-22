;
; AssemblerApplication1.asm
;
; Created: 2/7/2023 9:01:57 PM
; Author : smblackwll
;

;config
sbi DDRB,3 ;set PB3 output (pin 11 on board) (14 on Counter)
sbi DDRB,2 ;set PB2 output (pin 10 on board) (pin 11 on counter)
sbi DDRB,1 ;set PB1 output (pin 9 on board) (pin 13 on counter)
cbi DDRB,0 ;set PB0 input (pin 8) (to upper left on button A)
cbi DDRB,4 ;set PD7 input, pin 7, on upper left button B

.equ count = 0xfff		; assign a 16-bit value to symbol "count"
.equ fourth_count = 0xff1 


.equ disp0 = 0x3F
.equ disp1 = 0x6
.equ disp2 = 0x5B
.equ disp3 = 0x4F
.equ disp4 = 0x66
.equ disp5 = 0x6D
.equ disp6 = 0x7C
.equ disp7 = 0x7
.equ disp8 = 0x7F
.equ disp9 = 0x6F
.equ dispFlash = 0x80


ldi R16,0x00
ldi R23, 0
ldi R21, 0x00
ldi R18,disp0

; Replace with your application code
start:



SBIs PINB,0
rjmp press

SBIS PINB,4
rjmp countdown

;SBIC PIND,7
;rjmp countdown


rcall display ; call display subroutine

rjmp start





press:
	;rcall delay_long
	;rcall countA
	clr R23 
	ldi r25, 20
	loop3:

	sbic PINB, 0
	rjmp upOne

	rcall delay_long
	dec r25
	brne loop3

	/*tst R21
	breq onZero

	cpi R21, 0x3E
	brlo upOne

	cpi R21, 0x3F
	brge reset*/

	rjmp reset

	upOne:
	inc R16
	clr R21
	rjmp count_to_digital
	rjmp start

	reset:
	clr R16
	clr R21
	rjmp count_to_digital
	rjmp start

	



	;go into countA, and inc, then call a delay.
	;if the counter is 4 or less, only inc R16 by 1, otherwise, reset R16

	midway:
	rjmp start


display: ; backup used registers on stack
push R19
push R18
push R20
push R17
in R17, SREG
push R17
ldi R17, 8 ; loop --> test all 8 bits
loop:
	
	
	rol R18
	
	BRCS set_ser_in_1 ; branch if Carry is set; put code here to set SER to 0 
	cbi PORTB,3

	rjmp end


set_ser_in_1:
	sbi PORTB,3
	
end:
	sbi PORTB,2
	cbi PORTB,2
; put code here to generate SRCLK pulse...
	dec R17
	brne loop
	; put code here to generate RCLK pulse
	sbi PORTB,1
	cbi PORTB,1
	; restore registers from stack
	pop R17
	out SREG, R17
	pop R17
	pop R20
	pop R18
	pop R19

	ret  

count_to_digital:
	cpi R16, 0x00
	breq check_0
	cpi R16, 0x01
	breq check_1
	cpi R16, 0x02
	breq check_2
	cpi R16, 0x03
	breq check_3
	cpi R16, 0x04
	breq check_4
	cpi R16, 0x05
	breq check_5
	cpi R16, 0x06
	breq check_6
	cpi R16, 0x07
	breq check_7
	cpi R16, 0x08
	breq check_8
	cpi R16, 0x09
	breq check_9
	cpi r16, 9
	brge midway
	check_0:
		clr R18
		ldi R18, disp0

		cpi R23, 1
		breq check_0
		
		cpi R23,0
		breq midway

		;sbic PINB, 0
		;rjmp start
		;rjmp check_0

	check_1:
		clr R18
		ldi R18, disp1
		rjmp start
	check_2:
		clr R18
		ldi R18, disp2
		rjmp start
	check_3:
		clr R18
		ldi R18, disp3
		rjmp start
	check_4:
		clr R18
		ldi R18, disp4
		rjmp start
	check_5:
		clr R18
		ldi R18, disp5
		rjmp start
	check_6:
		clr R18
		ldi R18, disp6
		rjmp start
	check_7:
		clr R18
		ldi R18, disp7
		rjmp start
	check_8:
		clr R18
		ldi R18, disp8
		rjmp start
	check_9:
		clr R18
		ldi R18, disp9
		rjmp start

;loop:
;sbi   PORTB,1     ; LED at PB1 off
;cbi   PORTB,2     ; LED at PB2 on
;rcall delay_long  ; Wait
;cbi   PORTB,1     ; LED at PB1 on
;sbi   PORTB,2     ; LED at PB2 off
;rcall delay_long  ; Wait
;rjmp   loop


; Generate a delay using two nested loops that do "nothing".
; With a 16 MHz clock, the values below produce a ~4,194.24 ms delay.
;--------------------------------------------------------------------

/*countA:
	inc R21
	rcall delay_long
	

	rjmp start 
*/	



; To loop for a second, do a very similar loop with a delay, if the buttonB is pressed, and increment down per second



delay_long:  ;delay for 0.16 sec
	ldi r30, low(count)	  	; r31:r30  <-- load a 16-bit value into counter register for outer loop
	ldi r31, high(count);
d1:
	ldi   r29, 0xf		    	; r29 <-- load a 8-bit value into counter register for inner loop
d2:
	nop											; no operation
	dec   r29            		; r29 <-- r29 - 1
	brne  d2								; branch to d2 if result is not "0"
	sbiw r31:r30, 1					; r31:r30 <-- r31:r30 - 1
	brne d1									; branch to d1 if result is not "0"
	ret			
	

countdown:
	loop2:
		inc R23
		dec r16
		rjmp count_to_digital
		

/*	flash:
	ldi R22, 4 

	loopFlash:
		rcall delay_long
		rcall delay_long
		rcall delay_long
		rcall delay_long
		ldi R16, dispFlash
		rjmp count_to_digital
		dec R22
		brne loopFlash
	

	down_one:
		ldi R24, 20


		loopSec:
		rcall delay_long
		dec R16
		rjmp count_to_digital
		dec r24
		brne loopSec

		rjmp flash*/

		rjmp start

