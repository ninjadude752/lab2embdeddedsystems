;
; AssemblerApplication1.asm
;
; Created: 2/7/2023 9:01:57 PM
; Author : smblackwll
;

;config
sbi DDRB,3 ;set PB3 output
sbi DDRB,2 ;set PB2 output
sbi DDRB,1 ;set PB1 output
cbi DDRB,0 ;set PB0 input

; Replace with your application code
start:
; display a digit 
ldi R16, 0x3F  ; load pattern to display
ldi R18, 0x7 ;load pattern for button press
rcall display ; call display subroutine
rjmp start


display: ; backup used registers on stack
push R16
push R18
push R17
in R17, SREG
push R17
ldi R17, 8 ; loop --> test all 8 bits
loop:
	BRCS check_button ; branch if button is pressed, otherwise, set display to R16
	rol R16 ; rotate left trough Carry
	
	BRCS set_ser_in_1 ; branch if Carry is set; put code here to set SER to 0 
	cbi PORTB,3
	
	rjmp end

set_ser_in_1:
	sbi PORTB,3

check_button:
	rol R18

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
	pop R16

	ret  
