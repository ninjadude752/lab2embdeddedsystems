;
; AssemblerApplication1.asm
;
; Created: 2/7/2023 9:01:57 PM
; Author : smblackwll
;

;config
sbi DDRB,3 ;set PB3 output (pin 11)
sbi DDRB,2 ;set PB2 output (pin 10)
sbi DDRB,1 ;set PB1 output (pin 9)
cbi DDRB,0 ;set PB0 input (pin 8)

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




; Replace with your application code
start:
; display a digit 
;ldi R8, disp9 ;Load Pattern 9
;ldi R9, disp8 ;Load Pattern 8
;ldi R10, disp7 ;Load Pattern 7
;ldi R11, disp6 ;Load Pattern 6
;ldi R12, disp5 ; Load Pattern 5
;ldi R13, disp4 ;Load Pattern "4"
;ldi R14, disp3 ;Load pattern "3"
;ldi R19, disp2 ;load pattern "2"
ldi R16, disp1  ; load pattern on button press
ldi R18, disp0 ;load pattern for start display
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
	
	SBIC PINB,0
	rol R18


	SBIS PINB,0
	rol R16 ; rotate left trough Carry
	
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
	pop R16

	ret  


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

;.equ count = 0x6B33		; assign a 16-bit value to symbol "count"

;delay_long:
	;ldi r30, low(count)	  	; r31:r30  <-- load a 16-bit value into counter register for outer loop
	;ldi r31, high(count);
;d1:
	;ldi   r29, 0x4E		    	; r29 <-- load a 8-bit value into counter register for inner loop
;d2:
	;nop											; no operation
	;dec   r29            		; r29 <-- r29 - 1
	;brne  d2								; branch to d2 if result is not "0"
	;sbiw r31:r30, 1					; r31:r30 <-- r31:r30 - 1
	;brne d1									; branch to d1 if result is not "0"
	;ret				
