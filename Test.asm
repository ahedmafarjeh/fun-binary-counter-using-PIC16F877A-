
   	PROCESSOR 16F877A
	__CONFIG 0x3731

	cblock 0x25
count	
delay1	
delay2	
bt1_count


	endc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; regester LABEL EQUATES	;;;;;;;;;;;;;;;;;;;;;;;;;;;

PORTB	EQU		06 
PORTD	EQU     08	
TRISD	EQU		88
TRISB	EQU		86

; PROGRAM BEGINS    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ORG	0		; Default start address 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

banksel TRISD
movlw 0
movwf TRISD
banksel PORTD
loop
bsf PORTD,0
goto loop


end