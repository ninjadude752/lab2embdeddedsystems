;
; AssemblerApplication1.asm
;
; Created: 2/7/2023 9:01:57 PM
; Author : smblackwll
;


; Replace with your application code
start:
; display a digit 
ldi R16, 0x70 ; load pattern to display
rcall display ; call display subroutine



display: ; backup used registers on stack
push R16
push R17
in R17, SREG
push R17
ldi R17, 8 ; loop --> test all 8 bits
loop:
	rol R16 ; rotate left trough Carry
	BRCS set_ser_in_1 ; branch if Carry is set; put code here to set SER to 0
	
	rjmp end
set_ser_in_1:
	

end:
; put code here to generate SRCLK pulse...
	dec R17
	brne loop
	; put code here to generate RCLK pulse
	...
	; restore registers from stack
	pop R17
	out SREG, R17
	pop R17
	pop R16

	ret  


